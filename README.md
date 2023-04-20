# SharePoint Mapper

## Table of Contents
- [Introduction](#introduction)
- [How to install it](#how-to-install-it)
- [How to use it](#how-to-use-it)
- [Contact details](#contact-details)
- [License](#license)


## Introduction

This program builds a site map of a Microsoft Sharepoint site.  It uses
web browser logs.  Only parts of the site visited by the browser are included.

This is useful for a few reasons:

 * Sharepoint is slow to navigate.  In Firefox, each click takes about a minute
   on my computer.
 * Sharepoint sites can get out of control, and it's hard to find anything,
   or figure out how to reorganise it.


## How to install it

1. Install R -- see [these instructions](https://techvidvan.com/tutorials/install-r/).

2. Download [sharepoint-mapper.R](https://github.com/andrewclausen/sharepoint-mapper/blob/main/sharepoint-mapper.R)

3. Sharepoint-mapper requires some extra R packages (magrittr and jsonlite).
   However, these are installed automatically the first time you use it, so
   you do not need to do anything about these.


## How to use it

 1. Open a web browser.  Most modern browsers -- including Brave, Chrome, Edge,
    Firefox and Safari -- have the requisite support for logging with HAR
    ("HTTP archive") files.  Since Sharepoint is quite slow, I recommend a fast
    browser like Chrome.

 2. Open the SharePoint site you want to map.

 3. Enable activity logging, e.g. in Firefox or Chrome, do this by opening the
    developer tools by pressing F12.

 4. Visit the parts of the site that you want to map.

 5. Save the log as a HAR file, e.g. in Firefox or Chrome, select "Network" on
    the developer tool panel, and click the down arrow to save the activity log
    as a HAR file.

 6. Run sharepoint-mapper.R in the same folder to produce a site map in Markdown
    format (site-map.md).  You can do this from the command line, or within
    R by typing

                source("sharepoint-mapper.R")

 7. Use [Pandoc](https://pandoc.org/) to convert the site map into HTML, Word,
    etc.  For example, you might type

                pandoc site-map.md -o site-map.html --standalone


## Contact details

Pull requests are welcome.

 * website: <https://github.com/andrewclausen/sharepoint-mapper>
 * author: Andrew Clausen <andrew.clausen@ed.ac.uk>


## License

Copyright © 2023 by Andrew Clausen

You may freely use, modify and distribute this under the terms of the
[BSD licence](https://opensource.org/license/bsd-2-clause/).

