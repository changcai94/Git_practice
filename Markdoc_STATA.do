*****************************************************************************************
* Filename:  	Dinamic Documents 
* Purpose:      Introduction to dinamic documents
* Author:     	Gina La Hera-Fuentes
* Created:      September-2021
* Database: 	https://www.york.ac.uk/economics/hedg/software/
*				Describing health care costs and cost regressions  [AHE_2ed_Ch_3.dta]
* Requirements: ssc install markdoc, ssc install weaver, ssc install statax 
* Adapted from BITSS
*****************************************************************************************

     
	 set linesize 90
	 cd "~/Documents/Workshop/"
	 
	 sysuse AHE_2ed_Ch_3, clear
	 
	 capture quietly log close
     set more off
	 qui log using AHE_2ed_Ch_3, replace
	 

             /*** 
             Introduction to MarkDoc (heading 1) 
             =================================== 
    
             Markdown (heading 2)
             -------------------------- 
    
             Writing with __markdown__ syntax allows you to add text and graphs to
             _smcl_ logfile and export it to an editable document format. I will demonstrate
             the process by using an __open source__ dataset.

             ### Get started with MarkDoc (heading 3)
             I will open the dataset, list a few observations, and export a graph.
             Then I will export the logfile to Microsoft Office docx format.
			 
			 #### Even smaller bolding
			 
			 *italics*
			 
			 _one underscore_ is probably _also_ italics.
			 
             ***/

     /***/ sysuse AHE_2ed_Ch_3, clear 
     
	 //OFF
	 *When using OFF the text won't be included in the document
	 list in 1/5  
	 graph box age, by(female)
     graph export graph.png,  width(400) replace
	 
	 scatter totexp income
	 graph export graph2.tif,  width(400) replace
	 //ON
	 
     histogram age
     graph export graph3.png,  width(400) replace
	 
			/***
			You use two stars to include only output, and three stars to include 
			only the command.
			So two stars plus "quietly" gets you nothing.
			You can also add numbers inline, but it's not quite as smooth as in R Markdown.
			***/
			
	/***	
	TRY TO GET 1:both results & code 
	***/
	summ age
	
	/***
	
	2: results only
	***/
	
	/**/ summ age
	
	/***
	3: code only
	***/
	/***/ summ age
	
	/***
	4: neither
	***/
	
	//OFF
	summ age
	//ON
	
	txt "The average _age_ is " %9.2f r(mean) " with an standard deviation of " %9.2f r(sd)
	txt "The _age_ ranges from  " %9.0f r(min) " to " %9.0f r(max)

             /*** 
             Adding a graph or image in the report 
             ====================================== 

             Boxplot & Scatterplot
             -----------------------------
    
             In order to add a graph using Markdown, I export the graph in PNG format.
             You can explain the graph in the "brackets" and define the file path in parentheses
             
             ![explain the graph](./graph.png)
			 
			 You can also export to different file types. 
			 
			 ![explain the graph](./graph2.tif)
             
			 Let's try and add an equation at the bottom. 
			 
			 $y_i=\alpha+\beta_1*X_i$
				
							
			 ***/
	//OFF
	desc
	//ON	
			
			/*** 
             Including Tables
             ====================================== 

			 ***/ 
			 
	//OFF
		foreach var of varlist totexp income age educyr {
		summarize `var'
		local `var'_N : display %9.0f r(N) 
		local `var'_mean : display %9.2f r(mean) 
		local `var'_sd : display %9.2f r(sd)
		}
	//ON
			
		tbl ("Variable", "Observations", "Mean", "SD" \  ///
		"__Expediture__", `totexp_N' ,`totexp_mean', `totexp_sd' \ /// 
		"__Income__", `income_N',`income_mean', `income_sd' \ /// 
		"__Age__", `age_N', `age_mean', `age_sd', \ /// 
		"__Education__", `educyr_N', `educyr_mean', `educyr_sd'), /// 
		title("Table 1. Summary of the __expediture__, __income__, __age__ and" ///
		"__education__ variables")
	
	//OFF		
		reg totexp income female suppins phylim actlim totchr
		matrix b_se = get(_b)' , vecdiag(cholesky(diag(vecdiag(get(VCE)))))'
		matrix colnames b_se = totexp totexp_se
		matrix list b_se
	//ON
		
			/***
			Regression model _reg totexp income female suppins phylim actlim totchr_
			***/
	/**/ frmttable, statmat(b_se) substat(1) sdec(3)
	
	
	//OFF
	eststo m1: regress totexp income female suppins phylim actlim totchr 		
	eststo m2: regress totexp income female suppins phylim actlim 
	coefplot m1 m2, drop(_cons) xline(0)
	graph export graph4.png,  width(500) replace
	//ON
	
	esttab // se ar2
	
	//OFF
	matrix mean_sd = J(4,2,.)
	local i = 1
	foreach v in totexp income age educyr {
	summ `v'
	matrix mean_sd[`i',1] = r(mean) 
	matrix mean_sd[`i',2] = r(sd) 
	local i = `i' + 1
	}
	matrix rownames mean_sd = Expediture Income Age Education
	matrix list mean_sd 
	//ON
	
	
	
		/*** 
		Including graphs
		
		![Coefplot: m1: regress totexp income female suppins phylim actlim totchr, m2=m1 excluding totchr](./graph4.png)
		***/			
			 

     qui log close

    
     markdoc AHE_2ed_Ch_3, replace export(docx)
    *markdoc example, replace export(html) install mathjax                        
	*markdoc example, replace export(tex) texmaster
    *markdoc example, replace
    *markdoc example, replace export(epub)
