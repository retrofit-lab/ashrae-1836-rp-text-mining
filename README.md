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

### 1836-RP list of characterization properties
The file [eem-char-prop.csv](data/eem-char-prop.csv) contains the complete list of EEM characterization properties collected as part of 1836-RP.  This data file is not used in any of the analysis files posted here.  This data file was used to develop a list of recommended standardized characterization properties as part of 1836-RP, which are detailed in the 1836-RP Final Report.  

The characterization properties were collected from 17 different source documents assembled and analyzed in the literature review 1836-RP.  In addition to the 16 sources used to develop the main list of 3,480 EEMs, ASHRAE Standard 211-2018 was included as an additional source for characterization properties.  While it does not contain an enumerated list of EEMs and was therefore not used as a source for the main list of EEMs, it does contain EEM data collection properties in Normative Annex C and was therefore added to the list of sources for EEM characterization properties 

The file contains five variables:

-	`prop_id`: A unique ID assigned to each characterization property in the list.
-	`document` : An alphanumeric abbreviation code 3-6 characters in length representing the name of the original source document from which the characterization property was collected. The file contains one source docuement in addition to the 16 documents contained in the file [eem-list-main.csv](data/eem-list-main.csv).  This additional code and corresponding citation is:

    | Document | Citation |
    | ----------- | ----------- |
    | STD211 | ASHRAE. 2018. ASHRAE Standard 211-2018, Standard for Commercial Building Energy Audits. Atlanta: ASHRAE. |

-	`prop_name`: The name of the characterization property as written in the original source document.
-	`group`: An author-coded categorization describing which aspect of an EEM the characterization property describes.  There are four levels of this variable:
    -	`description`: The characterization property describes the EEM itself (e.g., measure status), rather than the benefits resulting from the EEM.
    -	`economics`: The characterization property describes the economic benefits of the EEM (e.g., payback).
    -	`savings`: The characterization property describes the savings (e.g., energy, demand, cost, carbon) associated with the EEM. 
    -	`nonenergy impacts`: The characterization property describes nonenergy benefits associated with the EEM (e.g., impact on indoor air quality and thermal comfort). 
-	`level`: An author-coded categorization describing whether the characterization property describes the EEM itself, or describes the building to which the EEM would be applied.  There are two levels of this variable:
    -	`EEM`: The characterization property describes the EEM itself (e.g., natural gas savings).
    -	`project`: The characterization property describes the building (or buildings) to which the EEM would be applied (e.g., gross floor area).

### 1836-RP list of categorization tags 
The file [categorization-tags.csv](data/ategorization-tags.csv) contains the list of element and descriptor tags used for categorizing EEMs according to the 1836-RP standardized system.  This data file is used for the EEM categorization analysis in [eem-categorization.Rmd](analysis/eem-categorization.Rmd).  The 1836-RP standardized categorization system consists of two parts: a three-level building element-based categorization hierarchy provided by UNIFORMAT, and a set of three measure name tags representing the key features of any EEM name: an action, the element of the building being acted upon, and additional descriptors.  Only the element tag is used to categorize a given EEM on the UNIFORMAT hierarchy.  Complete details on the categorization system are provided in the 1836-RP Final Report. 

An initial list of 70 element tags and 96 descriptor tags was developed as part of 1836-RP and was used to categorize and analyze existing lists of EEMs.  The initial list of tags was developed through analysis of the main list of 3,480 EEMs and a review of terminology from the [Building Energy Data Exchange Specification (BEDES)](https://bedes.lbl.gov/).  Each element tag was matched with a single UNIFORMAT category to facilitate element-based categorization of an EEM.  Descriptor tags were matched with a single UNIFORMAT category where possible.  Where possible, tags were matched with a Level 3 (i.e., lowest-level) UNIFORMAT category, however, in some cases, tags (e.g., “envelope”) were too broad for Level 3 and were matched with a Level 1 or Level 2 category instead.  Descriptor tags that could match with multiple UNIFORMAT categories (e.g., “insulation”) were left unassigned. 

The file contains six variables:

- `tag` : The term used for labeling an EEM containing that term.
- `type`: An author-coded categorization describing whether the tag is an element-type tag or a descriptor-type tag.  Element tags must match with one and only one UNIFORMAT category, and are used for categorization on the UNIFORMAT hierarchy.
- `uni_code`: Alphanumeric code given in UNIFORMAT for the lowest level at which the tag could be classified on the UNIFORMAT hierarchy.  UNIFORMAT has a single letter code for Level 1, a three character alphanumeric code for Level 2, and a five character alphanumeric code for Level 3.  If tag could not be assigned to a single UNIFORMAT category, the code “X0000” was used.  
- `uni_level_1`: UNIFORMAT Level 1 (Major Group Elements) classification for the tag.  If tag could not be assigned to a single UNIFORMAT category at this level, the classification “Unassigned” was used. 
- `uni_level_2`: UNIFORMAT Level 2 (Group Elements) classification for the tag.  If tag could not be assigned to a single UNIFORMAT category at this level, the classification “Unassigned” was used. 
- `uni_level_3`: UNIFORMAT Level 2 (Individual Elements) classification for the tag.  If tag could not be assigned to a single UNIFORMAT category at this level, the classification “Unassigned” was used.

### 1836-RP 5% sample list of EEMs
The file [eem-list-5sample.csv](data/eem-list-5sample.csv) contains a random subsample of approximately 5% of the 3,480 EEMs in the 1836-RP main list of EEMs.  This data file is used for the EEM categorization analysis in [eem-categorization.Rmd](analysis/eem-categorization.Rmd).  This sample was generated by taking a random sample in R, and was used to test the performance of the standardized categorization system on a wide variety of EEMs.  The file contains the same five variables as the [eem-list-main.csv](data/eem-list-main.csv) file.

### 1836-RP BuildingSync list of EEMs
The file [eem-list-bsync.csv](data/eem-list-bsync.csv) contains all of the EEMs in BuildingSync.  This data file is used for the EEM categorization analysis in [eem-categorization.Rmd](analysis/eem-categorization.Rmd).  The EEMs with the document_code BSYNC were extracted from the 1836-RP main list of EEMs.  The file was used to test the performance of the standardized categorization system on a single source list of EEMs.  The file contains the same five variables as the [eem-list-main.csv](data/eem-list-main.csv) file.

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
