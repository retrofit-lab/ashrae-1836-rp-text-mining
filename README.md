# ASHRAE 1836-RP: Developing a standardized categorization system for energy efficiency measures
This repository contains the data and code related to ASHRAE Research Project 1836, Developing a standardized categorization system for energy efficiency measures. 

## Contents  
- [Citation](#citation)  
- [Related Publications](#related-publications)  
- [Repository Structure](#repository-structure)  
- [Objective](#objective)  
- [Data](#data)  
    - [1836-RP main list of EEMs](#1836-rp-main-list-of-eems)  
    - [1836-RP list of characterization properties](#1836-rp-list-of-characterization-properties)  
    - [1836-RP list of categorization tags](#1836-rp-list-of-categorization-tags)  
    - [1836-RP 5% sample list of EEMs](#1836-rp-5-sample-list-of-eems)  
    - [1836-RP BuildingSync list of EEMs](#1836-rp-buildingsync-list-of-eems)  
- [Analysis](#analysis)  
    - [Text mining and topic modeling](#text-mining-and-topic-modeling)  
    - [Categorizing EEMs using the 1836-RP standardized system](#categorizing-eems-using-the-1836-rp-standardized-system)  

## Citation
TEXT TK

## Related Publications
TEXT TK

## Repository Structure
The repository is divided into three directories:
- `/data/`: Datasets created as part of 1836-RP
- `/analysis/`: R Markdown files for analysis related to 1836-RP
- `/results/`: Output produced by R Markdown files.  Each .Rmd file has an associated output subfolder.

## Objective
Energy efficiency measures (EEMs) are the fundamental mechanism for improving energy performance in buildings, however, there is currently no standardized way to describe or categorize EEMs in industry.  This lack of standardization severely limits the ability to communicate the intent of an EEM clearly and consistently, and to perform “apples-to-apples” comparisons of measure savings and cost effectiveness at multiple scales

To address this barrier, the objective of ASHRAE 1836-RP was to develop a standardized system for the categorization and characterization of EEMs. Categorization and characterization were two distinct parts of the project. Categorization arranges an EEM (or a set of EEMs) in relation to others, and was the primary objective of the project. Characterization describes a single specific instance of an EEM using a set of properties, and was a secondary objective. 

## Data
There are five datasets associated with this project. 

### 1836-RP main list of EEMs
The file [eem-list-main.csv](data/eem-list-main.csv) contains the complete list of 3,480 EEMs assembled and analyzed as part of 1836-RP.  This data file is used for the text mining analysis in [text-mining.Rmd](analysis/text-mining.Rmd).  The EEMs were collected from 16 different source documents during the 1836-RP literature review from September 2019 through July 2020.  An initial list of suggested sources was provided by the members of the 1836-RP Project Advisory Board, and additional documents were added through the authors’ literature review.  In order for a source to be included in the review, it needed to contain a list of EEMs.

The file contains five variables:

-	`eem_id`: A unique ID assigned to each measure in the list.
-	`document` : An alphanumeric abbreviation code 3-6 characters in length representing the name of the original source document from which the measure was collected. The 16 document codes and their corresponding citations are:

    | Document | Citation |
    | ----------- | ----------- |
    | 1651RP | Glazer, Jason. 2015. Development of Maximum Technically Achievable Energy Targets for Commercial Buildings: Ultra-Low Energy Use Building Set. ASHRAE Research Project 1651-RP Final Report. Arlington Heights, IL: Gard Analytics. |
    | ATT | Pacific Northwest National Laboratory. 2020. "Audit Template." https://buildingenergyscore.energy.gov/. |
    | BCL | National Renewable Energy Laboratory. 2020. "Building Component Library." https://bcl.nrel.gov/. |
    | BEQ | ASHRAE. 2020. "Building EQ." https://buildingeq.ashrae.org/. |
    | BSYNC | National Renewable Energy Laboratory. 2020. "BuildingSync." https://buildingsync.net/. |
    | CBES | Lawrence Berkeley National Laboratory. 2020. "Commercial Building Energy Saver." http://cbes.lbl.gov/. |
    | DOTY | Doty, Steve. 2011. Commercial Energy Auditing Reference Handbook. 2nd ed. Boca Raton: Fairmont Press. |
    | IEA11 | Lyberg, Mats Douglas, ed. 1987. Source Book for Energy Auditors. Vol. 1. Stockholm, Sweden: Swedish Council for Building Research. https://www.iea-ebc.org/projects/project?AnnexID=11. |
    | IEA46 | Zhivov, Alexander, and Cyrus Nasseri, eds. 2014. Energy Efficient Technologies and Measures for Building Renovation: Sourcebook. IEA ECBS Annex 46. https://www.iea-ebc.org/Data/publications/EBC_Annex_46_Technologies_and_Measures_Sourcebook.pdf. |
    | ILTRM | Illinois Energy Efficiency Stakeholder Advisory Group. 2019. 2020 Illinois Statewide Technical Reference Manual for Energy Efficiency Version 8.0. https://www.ilsag.info/technical-reference-manual/il_trm_version_8/. |
    | NYTRM | New York State Joint Utilities. 2019. New York Standard Approach for Estimating Energy Savings from Energy Efficiency Programs - Residential, Multi-Family, and Commercial/Industrial Measures Version 7. http://www3.dps.ny.gov/W/PSCWeb.nsf/All/72C23DECFF52920A85257F1100671BDD. |
    | REMDB | National Renewable Energy Laboratory. "National Residential Energy Efficiency Measures Database, Version 3.1.0." https://remdb.nrel.gov/. |
    | STD100 | ASHRAE. 2018. ASHRAE Standard 100-2018, Energy Efficiency in Existing Buildings. Atlanta: ASHRAE |
    | THUM | Thumann, Albert, ed. 1992. Energy Conservation in Existing Buildings Deskbook. Lilburn, GA: Fairmont Press. |
    | WSU | Washington State University Cooperative Extension and Energy Program. 2003. Washington State University Energy Program Energy Audit Workbook. WSUCEEP2003-043. http://www.energy.wsu.edu/PublicationsandTools.aspx. |
    | WULF | Wulfinghoff, Donald. 1999. Energy Efficiency Manual: For Everyone Who Uses Energy, Pays for Utilities, Controls Energy Usage, Designs and Builds, Is Interested in Energy and Environmental Preservation. Wheaton, MD: Energy Institute Press. |

-	`cat_lev1`: The name of the Level 1 category (i.e., highest level) under which the measure was categorized in the original source document.
-	`cat_lev2`: The name of the Level 2 category (i.e., subcategory, if present), under which the measure was categorized in the original source document.  If a Level 2 category was not present, the value of this variable was coded as “0”. 
-	`eem_name`: The name of the measure as written in the original source document.

## Analysis
There are two analysis files associated with this project.  

### Text mining and topic modeling
The list of 3,480 EEMs was analyzed using text mining and topic modeling to discover trends in how existing sources describe and organize EEMs.  These findings were used to help develop the standardized categorization system.  

-	[text-mining.Rmd](analysis/text-mining.Rmd)

The output from this file is located in `/results/text-mining/`.

### Categorizing EEMs using the 1836-RP standardized system
The performance of the standardized categorization system was tested using subsamples from the main list of 3,480 EEMs.  This code can be used to automatically categorize any existing list of EEMs according to the 1836-RP standardized system. 

-	[eem-categorization.Rmd](analysis/eem-categorization.Rmd)

The output from this file is located in `/results/categorization/`.
