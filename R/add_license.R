#' Add a LICENSE.txt file to your course
#' 
#' Licensing your course is important if you want to share your course. For more
#' information see \url{https://github.com/swirldev/swirlify/wiki/Licensing-Your-Course}.
#' For more information about Creative Commons licenses see \url{http://creativecommons.org/licenses/}.
#' For more information about software licenses see \url{http://www.gnu.org/licenses/license-list.en.html}.
#'
#' @param author The author of the course. This can be an organization.
#' @param year The year the course was written.
#' @param open_source_content If \code{TRUE} a Creative Commons content license
#' will be included pertaining to the content of your course.
#' @param content_license Specify which Creative Commons license you would like
#' to use for the content of your course. This must be equal to one of the
#' following: \code{"CC BY 4.0"}, \code{"CC BY-SA 4.0"}, \code{"CC BY-ND 4.0"},
#' \code{"CC BY-NC 4.0"}, \code{"CC BY-NC-SA 4.0"}, \code{"CC BY-NC-ND 4.0"},
#' or \code{"CC0"}.
#' @param open_source_data If \code{TRUE} a Creative Commons content license
#' will be included pertaining to the data distributed with your course.
#' @param data_license Currently this value must be equal to \code{"CC0"}, but
#' in the future it may be able to be other values.
#' @param open_source_code If \code{TRUE} a free software license
#' will be included pertaining to the software included in your course.
#' @param code_license Specify which open source software license you would like
#' to use for the content of your course. This must be equal to one of the
#' following: \code{"MIT"}, \code{"GPL3"}, \code{"CC0"}.
#' @importFrom whisker whisker.render
#' @export
#' @examples
#' \dontrun{
#' 
#' # Add a license with simple open source options
#' add_license("Team swirl")
#' 
#' # Add a license so that derivative works are shared alike
#' add_license("Team swirl", content_license  = "CC BY-SA 4.0", code_license ="GPL3")
#' 
#' # Add a license that reserves all of the author's rights
#' add_license("Team Bizzaro swirl", open_source_content = FALSE,
#'                                   open_source_data = FALSE,
#'                                   open_source_code = FALSE)
#' }
add_license <- function(author, year = format(Sys.Date(), "%Y"), 
                        open_source_content = TRUE,
                        content_license = "CC BY 4.0",
                        open_source_data = TRUE,
                        data_license = "CC0",
                        open_source_code = TRUE,
                        code_license = "MIT"){
  lesson_file_check()
  
  if(file.exists(file.path(getOption("swirlify_course_dir_path"), "LICENSE.txt")) &&
       interactive()){
    prompt_result <- readline(paste0("LICENSE.txt already exists for ", 
                                     getOption("swirlify_course_name"), "\n",
                                     "Are you sure you want to overwrite it? Y/n "))
    if(prompt_result != "Y"){
      return(invisible(file.path(getOption("swirlify_course_dir_path"), "LICENSE.txt")))
    }
  }
  
  if(!open_source_content && !open_source_data && !open_source_code){
    cat(whisker.render("All code and content contained within this course is
Copyright {{{year}}} {{{author}}}. All rights reserved.", list(author=author,
                                                               year = year)),
        file = file.path(getOption("swirlify_course_dir_path"), "LICENSE.txt"))
    return(invisible(file.path(getOption("swirlify_course_dir_path"), "LICENSE.txt")))
  }
  license_text <- "Copyright {{{year}}} {{{author}}}"
  if(open_source_content){
    license_text <- paste0(license_text, "\n\nThe content of this course including but not limited to contents of the
lesson.yaml files enclosed are licensed {{{content_license}}}. For more information please
visit {{{content_license_url}}}")
  }
  if(open_source_data){
    if(data_license != "CC0") stop(paste0("An invalid value: '", data_license, "' was provided for the add_license function."))
    license_text <- paste0(license_text, "\n\nThe datasets contained in this course are dedicated to the public domain under
the CC0 license. For more information please visit 
https://creativecommons.org/publicdomain/zero/1.0/")
  }
  if(open_source_code){
    license_text <- paste0(license_text, "\n\nThe software contained in this course is subject to the following license:\n\n",
                           whisker.render("{{{software_license}}}", list(software_license=get_license(code_license))))
  }
  
  cat(whisker.render(license_text, 
                     list(year=year, author=author, 
                          content_license=content_license,
                          content_license_url=get_cc_url(content_license)
                      )),
      file = file.path(getOption("swirlify_course_dir_path"), "LICENSE.txt")
      )
}

get_cc_url <- function(x){
  cc_urls <- list(
    "CC BY 4.0" = "http://creativecommons.org/licenses/by/4.0/",
    "CC BY-SA 4.0" = "http://creativecommons.org/licenses/by-sa/4.0/",
    "CC BY-ND 4.0" = "http://creativecommons.org/licenses/by-nd/4.0/",
    "CC BY-NC 4.0" = "http://creativecommons.org/licenses/by-nc/4.0/",
    "CC BY-NC-SA 4.0" = "http://creativecommons.org/licenses/by-nc-sa/4.0/",
    "CC BY-NC-ND 4.0" = "http://creativecommons.org/licenses/by-nc-nd/4.0/",
    "CC0" = "https://creativecommons.org/publicdomain/zero/1.0/"
  )
  result <- cc_urls[[x]]
  if(is.null(result)){
    stop(paste0("An invalid value: '", x, "' was provided for the add_license function."))
  } else {
    result
  }
}

get_license <- function(x){
  license_dict <- list(
    "MIT" = 'Permission is hereby granted, free of charge, to any person obtaining a copy of 
this software and associated documentation files (the "Software"), to deal in 
the Software without restriction, including without limitation the rights to 
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do 
so, subject to the following conditions:
    
The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.
    
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
{{{author}}} BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN 
ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    
Except as contained in this notice, the name of {{{author}}} shall not be 
used in advertising or otherwise to promote the sale, use or other dealings in 
this Software without prior written authorization from {{{author}}}.',
  
    "GPL3" = 'The programs included in this course are free software: you can redistribute them and/or modify
them under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
    
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
    
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.',
  
    "CC0" = 'The code contained in this course is dedicated to the public domain under
the CC0 license. For more information please visit 
https://creativecommons.org/publicdomain/zero/1.0/')  
  result <- license_dict[[x]]
  if(is.null(result)){
    stop(paste0("An invalid value: '", x, "' was provided for the add_license function."))
  } else {
    result
  }
}