###################################### analysis of GWAS catalog summary statistics ######################################
require(readr)
require(stringr)
gwas_summary = read_tsv("list_gwas_summary_statistics.tsv")
pubmed_id_gwas = names(table(gwas_summary$`PubMed ID`))
pubmed_id_gwas_num = as.numeric(table(gwas_summary$`PubMed ID`))
hist(table(gwas_summary$`PubMed ID`))
num_gwas = length(pubmed_id_gwas)

# randomly sample one `study accession` from each PubMed ID
ac_gwas = character(num_gwas)
for(i in 1:num_gwas)
{
  ac = gwas_summary$`Study Accession`[which(gwas_summary$`PubMed ID`==as.numeric(pubmed_id_gwas[i]))]
  ac_gwas[i] = sample(ac,1)
}

# create a txt file containing the URL of each accession for the purpose of automatic file download
ac_gwas_con = character(num_gwas)
for(i in 1:num_gwas)
{
  ac = ac_gwas[i]
  n = as.numeric(paste0('1',str_sub(ac,-6,-4)))
  n1 = str_sub(as.character(n+1),-3,-1)
  ac_gwas_con[i] = paste0('ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/',
                          str_sub(ac,1,-7),str_sub(ac,-6,-4),'001-',
                          str_sub(ac,1,-7),n1,'000','/',
                          ac,'/') 
}


writeLines(ac_gwas_con, con = "pubmed_url_gwas.txt", sep = "\n")

# analysis of whether each study accession contains Xchr or Ychr results
allfiles = list.files(path = ".", pattern = "GCST*")
allchr = list()
for(f in allfiles)
{
  tfile = read_tsv(f)
  allchr = c(allchr, list(list(dir=f,chr=table(tfile$chromosome))))
}
save(allchr,file="allchr.Rdata")


load("allchr.Rdata")
load("allchr.Rdata")
targetind1 = c()
targetind2 = c()
for(i in 1:136)
{
  if(length(allchr[[i]]$chr)>22) targetind1 = c(targetind1, i)
  if(length(allchr[[i]]$chr)>23) targetind2 = c(targetind2, i)
}

ac_gwas_con = read.table("pubmed_url_gwas.txt")
ac_gwas_con = cbind.data.frame(`PubMed ID` = pubmed_id_gwas, Link = ac_gwas_con$V1, 
                               `# summary stat` = pubmed_id_gwas_num,
                               Xchr = as.numeric(c(1:136) %in% targetind1), 
                               Ychr = as.numeric(c(1:136) %in% targetind2))

writexl::write_xlsx(ac_gwas_con, path = "pubmed_link.xlsx")

