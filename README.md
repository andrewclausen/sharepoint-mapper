# SharePoint Mapper

This program builds a site map of a Microsoft Sharepoint site.  It uses
web browser logs.  Only parts of the site visited by the browser are included.

This is useful for a few reasons:

 * Sharepoint is slow to navigate.  In Firefox, each click takes about a minute
   on my computer.
 * Sharepoint sites can get out of control, and it's hard to find anything,
   or figure out how to reorganise it.


## How to install it

1. Install R -- see [these instructions](https://techvidvan.com/tutorials/install-r/).

2. Download [sharepoint-mapper.R](https://github.com/andrewclausen/sharepoint-mapper/sharepoint-mapper.R)


## How to use it:

 1. Open a web browser.  I recommend Google Chrome, because it is fast and has
    good developer tools.

 2. Open the SharePoint site you want to map.

 3. Enable the developer tools to log the tab's activity, e.g. by pressing F12.

 4. Visit the parts of the site that you want to map.

 5. On the developer tool panel, select "Network", and the down arrow to save
    the activity log as a HAR file.

 6. Run sharepoint-mapper.R in the same folder to produce a site map in Markdown
    format (site-map.md).  You can do this from the command line, or within
    R by typing

                source("sharepoint-mapper.R")

 7. Use [Pandoc](https://pandoc.org/) to convert the site map into HTML, Word,
    etc.


## Contact details

Pull requests are welcome.

 * website: <https://github.com/andrewclausen/sharepoint-mapper>
 * author: Andrew Clausen <andrew.clausen@ed.ac.uk>


## Licence

Copyright © 2023 by Andrew Clausen

You may freely use, modify and distribute this under the terms of the
[BSD licence](https://opensource.org/license/bsd-2-clause/).

