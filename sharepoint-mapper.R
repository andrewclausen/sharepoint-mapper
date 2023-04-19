#! /usr/bin/Rscript

# SharePoint Mapper
# https://github.com/andrewclausen/sharepoint-mapper
# Copyright © 2023, by Andrew Clausen <andrew.clausen@ed.ac.uk>

# This program builds a site map of Microsoft Sharepoint sites out of web
# browser logs.  Only parts of the site visited by the browser are included.

use_library <- function(pkgs)
{
	installed <- installed.packages()[, "Package"]
	missing_pkgs <- pkgs[!pkgs %in% installed]
	if (length(missing_pkgs) > 0)
		install.packages(pkgs)
	for (pkg in pkgs)
		library(pkg, character.only=TRUE)
}

use_library(c("jsonlite", "magrittr"))

# Normalise hyperlinks by dropping trailing slashes.
normalise_link <- function(x) sub("/*$", "", x)

# Extract Sharepoint folder listing data from web browser logs
# Each listing is inside an XHR request called RenderListDataAsStream
extract_raw_listings <- function(har)
{
	x <- har$log$entries
	I.listing <- grepl("RenderListDataAsStream", x$request$url)
	x$response$content$text[I.listing] %>% lapply(fromJSON)
}

# The Sharepoint web app encodes the folder-listing in a JSON file.
# This function returns the contents as a data frame with "name" and "link"
# columns.
parse_raw_listings <- function(x)
{
	if (!"FileLeafRef" %in% names(x$ListData$Row))
		return(list())
	items <- as.data.frame(x$ListData$Row)[c("FileLeafRef", "FileRef")]
	names(items) <- c("name", "link")
	items$link <- normalise_link(items$link)
	items$domain <- sub("/sites/.*$", "", x$HttpRoot)
	items$parent <- ifelse(
		grepl("/", items$link),
		sub("(.*)/[^/]*", "\\1", items$link),
		NA
	)

	items
}

# Load and parse Sharepoint listings
ingest_sessions <- function()
(
	as.list(list.files(pattern="[.]har$"))
	%>% lapply(fromJSON)
	%>% lapply(extract_raw_listings)
	%>% { do.call(c, .) }
	%>% lapply(parse_raw_listings)
	%>% { do.call(rbind, .) }
)

# Add in missing nodes in the tree, e.g. if the top-level node is missing.
add_missing_nodes <- function(items)
{
	missing_link <- items$parent[!items$parent %in% items$link]
	missing_domain <- items$domain[!items$parent %in% items$link]
	missing_name <- sub("^.*/([^/]*)$", "\\1", missing_link)
	missing_parent <- sub("^(.*)/[^/]*$", "\\1", missing_link)
	missing <- data.frame(
		name=missing_name, link=missing_link, domain=missing_domain, parent=missing_parent)
	rbind(items, missing)
}

# This function constructs a forest of trees out of a data frame of folder
# listings.
construct_trees <- function(df)
{
	items <- lapply(split(df, seq(nrow(df))), as.list)
	roots <- which(!df$parent %in% df$link)

	add_children <- function(i)
	{
		item <- items[[i]]
		children <- which(df$parent == df$link[i])
		item$children <- lapply(children, add_children)
		item
	}

	lapply(roots, add_children)
}

# Format hyperlinks in markdown format
format_link <- function(name, link)
	paste0("[", name, "]", "(", link, ")")

# Format a forest of folder listings as nested lists of links in Markdown
format_trees <- function(roots, indent=-1)
{
	spaces <- strrep(" ", max(0, indent * 2 + 1))
	if (indent == -1)
		bullet <- c("#")
	else
		bullet <- c("*", "-")[indent %% 2 + 1]
	result <- c()
	for (root in roots)
	{
		url <- paste0(root$domain, root$link)
		link <- format_link(root$name, url)
		line <- paste0(spaces, bullet, " ", link, "\n\n")
		child_lines <- format_trees(root$children, indent + 1)
		result <- c(result, line, child_lines)
	}
	paste(result, collapse="")
}

items <- ingest_sessions()
items <- add_missing_nodes(items)
items <- items[!duplicated(items$link), ]
trees <- construct_trees(items)
text <- format_trees(trees)
cat(text, file="site-map.md")

