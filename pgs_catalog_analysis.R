###################################### analysis of PGS catalog ######################################

# analysis of the downloaded files
allpgs = list.files(path = ".", pattern = "*.txt")
allchr = list()
for(f in allpgs)
{
  pfile = read.table(f, comment.char = "#")
  allchr = c(allchr, list(list(dir=f,chr=table(pfile$chr_name))))
}
save(allchr,file="allchr.Rdata")

# summarize
load("allchr_pgs.Rdata")
targetind1_pgs = c()
targetind2_pgs = c()
for(i in 1:430)
{
  if(length(allchr[[i]]$chr)>22) targetind1_pgs = c(targetind1_pgs, i)
  if(length(allchr[[i]]$chr)>23) targetind2_pgs = c(targetind2_pgs, i)
}


