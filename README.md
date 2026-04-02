# ACSmarriageandfert
Code accompanying Burke forthcoming in Demography. Analysis relies on data from the American Community Survey, accessed via IPUMS USA.

For questions, please contact Kristen Burke at kristen.burke@ucf.edu.

To use: 

- Download data from IPUMS USA from 2006-2023 containing variables:YEAR SAMPLE SERIAL CBSERIAL HHWT CLUSTER STRATA GQ PERNUM PERWT SEX AGE MARST MARRINYR FERTYR RACE RACED HISPAN HISPAND BPL BPLD SCHOOL EDUC EDUCD GRADEATT GRADEATTD
- Rename setup_<username>.do where <username> is the username on your computer
- Adjust file paths in setup_<username> to their appropriate locations
- Update data/acs_dataprep.do with Stata command file produced by IPUMS while retaining lines 1597-1600
- Update line 8 of analysis/F1nmfratio to point to the location of CDCbirthrates.txt
- Run main.do


NCHS sources for vital stats:
- 1960-1999 https://www.cdc.gov/nchs/data/nvsr/nvsr48/nvs48_16.pdf
- 2000 https://www.cdc.gov/nchs/data/nvsr/nvsr50/nvsr50_05.pdf
- 2001 https://www.cdc.gov/nchs/data/nvsr/nvsr51/nvsr51_02.pdf
- 2002 https://www.cdc.gov/nchs/data/nvsr/nvsr52/nvsr52_10.pdf
- 2003 https://www.cdc.gov/nchs/data/nvsr/nvsr54/nvsr54_02.pdf
- 2004 https://www.cdc.gov/nchs/data/nvsr/nvsr55/nvsr55_01.pdf
- 2005 https://www.cdc.gov/nchs/data/nvsr/nvsr56/nvsr56_06.pdf
- 2006 https://www.cdc.gov/nchs/data/nvsr/nvsr57/nvsr57_07.pdf
- 2007 https://www.cdc.gov/nchs/data/nvsr/nvsr58/nvsr58_24.pdf
- 2008 https://www.cdc.gov/nchs/data/nvsr/nvsr59/nvsr59_01.pdf
- 2009 https://www.cdc.gov/nchs/data/nvsr/nvsr60/nvsr60_01.pdf
- 2010 https://stacks.cdc.gov/view/cdc/231829
- 2011 https://www.cdc.gov/nchs/data/nvsr/nvsr62/nvsr62_01.pdf
- 2012 https://www.cdc.gov/nchs/data/nvsr/nvsr62/nvsr62_09.pdf
- 2013 https://www.cdc.gov/nchs/data/nvsr/nvsr64/nvsr64_01.pdf
- 2014 https://www.cdc.gov/nchs/data/nvsr/nvsr64/nvsr64_12.pdf
- 2015 https://pubmed.ncbi.nlm.nih.gov/28135188/
- 2016 https://www.cdc.gov/nchs/data/nvsr/nvsr67/nvsr67_01.pdf
- 2017 https://www.cdc.gov/nchs/data/nvsr/nvsr67/nvsr67_08-508.pdf
- 2018 https://stacks.cdc.gov/view/cdc/231883
- 2019 https://www.cdc.gov/nchs/data/nvsr/nvsr70/nvsr70-02-508.pdf
- 2020 https://www.cdc.gov/nchs/data/nvsr/nvsr70/nvsr70-17.pdf
- 2021 https://stacks.cdc.gov/view/cdc/122047
- 2022 https://www.cdc.gov/nchs//data/nvsr/nvsr73/nvsr73-02.pdf
- 2023 https://www.cdc.gov/nchs/data/nvsr/nvsr74/nvsr74-1.pdf