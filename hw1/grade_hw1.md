*George Dewey*

### Overall Grade: 102/110

### Quality of report: 10/10

-   Is the homework submitted (git tag time) before deadline? 

    Yes. `Jan 24, 2020, 11:54 PM PST`.

-   Is the final report in a human readable format html? 

    Yes. `html` file. 

-   Is the report prepared as a dynamic document (R markdown) for better reproducibility?

    Yes. `Rmd`.

-   Is the report clear (whole sentences, typos, grammar)? Do readers have a clear idea what's going on and how are results produced by just reading the report? 

	  Include questions followed by answers. 


### Correctness and efficiency of solution: 54/60

-   Q1 (10/10)

-   Q2 (16/20)

    
    \#4. 
    
      - (-1 pt) The answer you gave (46521 patients) does not match with the output from your code. `uniq` filters adjacent matching lines. Hence, need to `sort` first. e.g. 
	  
	    ```
	    awk -F ',' '{print $2}' /home/203bdata/mimic-iii/ADMISSIONS.csv | sort | uniq | wc -l
	    ```
	    This would give you 46521. Since you need to account for the header, the number of unique patients would be 46520. 
    	
      - (-3 pts) How many (unique) patients are Hispanic?
    
-   Q3 (15/15)

-   Q4 (13/15)
	
	
	  \#3. (-2 pts) Table looks crude. Use `kable` to print the table in the given format. 
	
	    
### Usage of Git: 10/10

-   Are branches (`master` and `develop`) correctly set up? Is the hw submission put into the `master` branch? 

    Yes. 

-   Are there enough commits? Are commit messages clear? 

    43 commits for hw1. 

          
-   Is the hw1 submission tagged? 

    Yes. `hw1`. 

-   Are the folders (`hw1`, `hw2`, ...) created correctly? 

    Yes.
  
-   Do not put a lot auxiliary files into version control. 

	  Yes. 
	  
### Reproducibility: 10/10

-   Are the materials (files and instructions) submitted to the `master` branch sufficient for reproducing all the results? Just click the `knit` button will produce the final `html` on teaching server? 

	  Yes.  
  
-   If necessary, are there clear instructions, either in report or in a separate file, how to reproduce the results?

    Yes.

### R code style: 18/20

-   [Rule 3.](https://google.github.io/styleguide/Rguide.xml#linelength) The maximum line length is 80 characters. 


-   [Rule 4.](https://google.github.io/styleguide/Rguide.xml#indentation) When indenting your code, use two spaces.

-   [Rule 5.](https://google.github.io/styleguide/Rguide.xml#spacing) Place spaces around all binary operators (=, +, -, &lt;-, etc.). 	
	
-   [Rule 5.](https://google.github.io/styleguide/Rguide.xml#spacing) Do not place a space before a comma, but always place one after a comma. (-2 pts)

    Some violations:
      - `autoSim.R`: lines 11, 13
      - `hw1.Rmd`: last code chunk (lines 252, 256, 268, 279)

-   [Rule 5.](https://google.github.io/styleguide/Rguide.xml#spacing) Place a space before left parenthesis, except in a function call.

-   [Rule 5.](https://google.github.io/styleguide/Rguide.xml#spacing) Do not place spaces around code in parentheses or square brackets.
