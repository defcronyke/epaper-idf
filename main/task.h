#ifndef __EPAPER_IDF_TASKS_H_INCLUDED__
#define __EPAPER_IDF_TASKS_H_INCLUDED__
/*  epaper-idf

		Copyright (c) 2021 Jeremy Carter <jeremy@jeremycarter.ca>

		This code is released under the license terms contained in the
		file named LICENSE, which is found in the top-level folder in
		this project. You must agree to follow those license terms,
		otherwise you aren't allowed to copy, distribute, or use any 
		part of this project in any way.
*/
#include "esp_system.h"

#define PROJECT_DEFINE_HEADER_HIDDEN(x) x
#define PROJECT_DEFINE_HEADER(x) PROJECT_DEFINE_HEADER_HIDDEN(x)

#ifdef CONFIG_PROJECT_MAIN_TASK_EXAMPLE_HTTP_SLIDESHOW
#define PROJECT_MAIN_TASK_HEADER "example/http-slideshow.h"
#elif CONFIG_PROJECT_MAIN_TASK_NONE
#define PROJECT_MAIN_TASK_HEADER "example/none.h"
#endif

#define PROJECT_MAIN_TASK_HEADER_INC PROJECT_DEFINE_HEADER(PROJECT_MAIN_TASK_HEADER)

#include PROJECT_MAIN_TASK_HEADER_INC

#endif
