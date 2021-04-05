/*  epaper-idf

		Copyright (c) 2021 Jeremy Carter <jeremy@jeremycarter.ca>

		This code is released under the license terms contained in the
		file named LICENSE, which is found in the top-level folder in
		this project. You must agree to follow those license terms,
		otherwise you aren't allowed to copy, distribute, or use any 
		part of this project in any way.
*/
#include "epaper-idf-task.h"

extern "C" void app_main(void)
{
	/** NOTE: This starts your main firmware task. You can select 
    which task you want to run in the Kconfig menu settings by
    running this command:
    
      idf.py menuconfig

    You'll choose between the provided examples, or your own 
    custom tasks which you added to the menu as per the provided 
    instructions. */
	main_fn();
}
