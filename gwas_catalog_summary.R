setwd("~/Desktop/chrX/")
library(data.table)
library(ggplot2)

chrstats <- read.table("chrLength.txt") # based on ensembl GRCh37.p13
chrstats$Mb <- as.numeric(gsub(",","",chrstats$V4)) / 1000000

gwas <- as.data.frame(fread("GWASCatalog_allassoc_1Dec2022.txt.gz",quote = "")) # Downloaded from GWAS catalog, Dec 1, 2022; Data were based on the most recent update on Nov 29, 2022
#gwassub_all <- unique(gwas[,c("PUBMEDID","DATE","JOURNAL","CHR_ID")])
gwassub_sig <- unique(gwas[as.numeric(gwas$`P-VALUE`) < 5e-8,c("PUBMEDID","DATE","JOURNAL","CHR_ID")])

#gwassub_all$Year <- as.numeric( unlist(lapply(strsplit(as.character(gwassub_all$DATE),"-"), function(x) x[1])) )
gwassub_sig$Year <- as.numeric( unlist(lapply(strsplit(as.character(gwassub_sig$DATE),"-"), function(x) x[1])) )

#gwassub_all$CHR_ID[grep(";",gwassub_all$CHR_ID)] <- unlist(lapply(strsplit(gwassub_all$CHR_ID[grep(";",gwassub_all$CHR_ID)],";"),function(x) x[1]))
#gwassub_all$CHR_ID[gwassub_all$CHR_ID=="X x X"] <- "X"
#gwassub_all$CHR_ID[grep("x",gwassub_all$CHR_ID)] <- "Inter-autosomal interaction"
#gwassub_all$CHR_ID <- factor(gwassub_all$CHR_ID, levels = c("","Inter-autosomal interaction",1:22,"X"))

#pltdatall <- data.frame(Number = as.numeric(sapply(2008:2022, function(x) as.vector(table(gwassub_all$CHR_ID[gwassub_all$Year <= x])))),
#                        Year = rep(c(paste0("Until ",2008:2021),"Until Nov 29, 2022"), each = 25),
#                        Chr = c("Un-annotated","Inter-autosomal interaction",paste0("chr",1:22),"chrX"))
#pltdatall$Chr <- factor(pltdatall$Chr, levels = c("Un-annotated","Inter-autosomal interaction",paste0("chr",1:22),"chrX"))
#pltdatall$ChrX <- ifelse(pltdatall$Chr=="chrX", "chrX", "other")

#ggplot(pltdatall, aes(x = Chr, y = Number, color = Chr, shape = ChrX)) +
#  geom_point() +
#  theme_bw() +
#  facet_wrap(Year ~., nrow = 3) +
#  theme(axis.text.x = element_blank(),
#        axis.ticks.x = element_blank(),
#        legend.position = "bottom",
#        strip.text = element_text(size = 13),
#        axis.title = element_text(size = 14),
#        axis.text = element_text(size = 13),
#        legend.text = element_text(size = 13)) +
#  labs(color = "") +
#  scale_color_manual(values = c("grey","darkgreen",rainbow(22),"black")) +
#  ggtitle("Number of studies reporting at least one association") +
#  xlab("Chromosome") +
#  ylab("") +
#  scale_shape_manual(values = c(4,16), guide = "none")

#pltdatall$Year <- rep(2008:2022, each = 25)
#ggplot(pltdatall, aes(x = Year, y = Number, color = Chr, shape = ChrX)) +
#  geom_point() +
#  geom_line(aes()) +
#  theme_bw() +
#  theme(axis.text.x = element_blank(),
#        axis.ticks.x = element_blank(),
#        legend.position = "bottom",
#        strip.text = element_text(size = 13),
#        axis.title = element_text(size = 14),
#        axis.text = element_text(size = 13),
#        legend.text = element_text(size = 13)) +
#  labs(color = "") +
#  scale_color_manual(values = c("grey","darkgreen",rainbow(22),"black")) +
#  ggtitle("Cumulative number of studies reporting at least one association") +
#  xlab("Publication year (2008 - Nov 29, 2022)") +
#  ylab("") +
#  scale_shape_manual(values = c(4,16), guide = "none")

#pltdatall <- pltdatall[!pltdatall$Chr %in% c("Un-annotated","Inter-autosomal interaction"),]
#pltdatall$Chr <- factor(pltdatall$Chr, levels = c(paste0("chr",1:22),"chrX"))
#pltdatall$ChrX <- ifelse(pltdatall$Chr=="chrX", "chrX", "other")
#pltdatall$Year <- rep(2008:2022, each = 23)
#for (j in seq(2022,2009,-1)) {
#  for (k in c(paste0("chr",1:22),"chrX")) {
#    pltdatall$Number[pltdatall$Year==j & pltdatall$Chr==k] <- pltdatall$Number[pltdatall$Year==j & pltdatall$Chr==k] - pltdatall$Number[pltdatall$Year==(j-1) & pltdatall$Chr==k]
#  }
#}

#pltdatall$Year <- rep(c("Until Dec 31, 2008",2009:2021,"Jan 1, 2022 - Nov 29, 2022"),each = 23)
#pltdatall$Year <- factor(pltdatall$Year, levels = c("Until Dec 31, 2008",2009:2021,"Jan 1, 2022 - Nov 29, 2022"))
#ggplot(pltdatall, aes(x = Chr, y = Number, color = Chr, shape = ChrX)) +
#  geom_point() +
#  theme_bw() +
#  facet_wrap(Year ~., nrow = 3) +
#  theme(axis.text.x = element_blank(),
#        axis.ticks.x = element_blank(),
#        legend.position = "bottom",
#        strip.text = element_text(size = 13),
#        axis.title = element_text(size = 14),
#        axis.text = element_text(size = 13),
#        legend.text = element_text(size = 13)) +
#  labs(color = "") +
#  scale_color_manual(values = c(rainbow(22),"black")) +
#  ggtitle("Number of studies reporting at least one association") +
#  xlab("Chromosome") +
#  ylab("") +
#  scale_shape_manual(values = c(4,16), guide = "none")

#pltdatall$Number.cm <- pltdatall$Number / chrstats$Mb[1:23]
#ggplot(pltdatall, aes(x = Chr, y = Number.cm, color = Chr, shape = ChrX)) +
#  geom_point() +
#  theme_bw() +
#  facet_wrap(Year ~., nrow = 3) +
#  theme(axis.text.x = element_blank(),
#        axis.ticks.x = element_blank(),
#        legend.position = "bottom",
#        strip.text = element_text(size = 13),
#        axis.title = element_text(size = 14),
#        axis.text = element_text(size = 13),
#        legend.text = element_text(size = 13)) +
#  labs(color = "") +
#  scale_color_manual(values = c(rainbow(22),"black")) +
#  ggtitle("Average number of studies reporting at least one association per Mb") +
#  xlab("Chromosome") +
#  ylab("") +
#  scale_shape_manual(values = c(4,16), guide = "none")



gwassub_sig$CHR_ID[grep(";",gwassub_sig$CHR_ID)] <- unlist(lapply(strsplit(gwassub_sig$CHR_ID[grep(";",gwassub_sig$CHR_ID)],";"),function(x) x[1]))
gwassub_sig$CHR_ID[gwassub_sig$CHR_ID=="X x X"] <- "X"
gwassub_sig$CHR_ID[grep("x",gwassub_sig$CHR_ID)] <- "Inter-autosomal interaction"
gwassub_sig$CHR_ID <- factor(gwassub_sig$CHR_ID, levels = c("","Inter-autosomal interaction",1:22,"X"))

pltdatsig <- data.frame(Number = as.numeric(sapply(2008:2022, function(x) as.vector(table(gwassub_sig$CHR_ID[gwassub_sig$Year <= x])))),
                        Year = rep(c(paste0("Until ",2008:2021),"Until Nov 29, 2022"), each = 25),
                        Chr = c("Un-annotated","Inter-autosomal interaction",paste0("chr",1:22),"chrX"))
pltdatsig$Chr <- factor(pltdatsig$Chr, levels = c("Un-annotated","Inter-autosomal interaction",paste0("chr",1:22),"chrX"))

pltdatsig$Year <- rep(2008:2022, each = 25)
pltdatsig <- pltdatsig[!pltdatsig$Chr %in% c("Un-annotated","Inter-autosomal interaction"),]
pltdatsig$Chr <- paste0(pltdatsig$Chr," (",round(chrstats$Mb[1:23])," Mb)")
pltdatsig$Chr <- factor(pltdatsig$Chr, levels = pltdatsig$Chr[1:23])
pltdatsig$ChrX <- ifelse(pltdatsig$Chr=="chrX (154 Mb)", "chrX", "other")

# Figure 1
ggplot(pltdatsig[pltdatsig$Year==2022,], aes(x = factor(c(1:22,"X"), levels = c(1:22,"X")), y = Number, color = Chr, shape = ChrX)) +
  geom_point(size = 3) +
  theme_bw() +
  theme(legend.position = "bottom",
        strip.text = element_text(size = 13),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 13),
        legend.text = element_text(size = 13)) +
  labs(color = "") +
  scale_color_manual(values = c(rainbow(22),"black")) +
#  ggtitle("Total number of studies reporting at least one genome-wide significant association") +
  xlab("Chromosome") +
  ylab("Number of studies") +
  scale_shape_manual(values = c(4,16), guide = "none") +
  scale_y_continuous(breaks = seq(0,1750,by = 250),limits = c(0,1750))

ggplot(pltdatsig[pltdatsig$Year==2022,], aes(x = factor(c(1:22,"X"), levels = c(1:22,"X")), y = Number/chrstats$Mb[1:23], color = Chr, shape = ChrX)) +
  geom_point(size = 3) +
  theme_bw() +
  theme(legend.position = "bottom",
        strip.text = element_text(size = 13),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 13),
        legend.text = element_text(size = 13)) +
  labs(color = "") +
  scale_color_manual(values = c(rainbow(22),"black")) +
#  ggtitle("Average number of studies reporting at least one genome-wide significant association per Mb") +
  xlab("Chromosome") +
  ylab("Number of studies / Mb") +
  scale_y_continuous(breaks = seq(0,18,by = 2), limits = c(0,18)) +
  scale_shape_manual(values = c(4,16), guide = "none")

pltdatsig$Year <- rep(2008:2022, each = 23)
for (j in seq(2022,2009,-1)) {
  for (k in pltdatsig$Chr[1:23]) {
    pltdatsig$Number[pltdatsig$Year==j & pltdatsig$Chr==k] <- pltdatsig$Number[pltdatsig$Year==j & pltdatsig$Chr==k] - pltdatsig$Number[pltdatsig$Year==(j-1) & pltdatsig$Chr==k]
  }
}

pltdatsig$Year <- rep(c("Until Dec 31, 2008",2009:2021,"Jan 1, 2022 - Nov 29, 2022"),each = 23)
pltdatsig$Year <- factor(pltdatsig$Year, levels = c("Until Dec 31, 2008",2009:2021,"Jan 1, 2022 - Nov 29, 2022"))

# Figure S1
ggplot(pltdatsig, aes(x = Chr, y = Number, color = Chr, shape = ChrX)) +
  geom_point() +
  theme_bw() +
  facet_wrap(Year ~., nrow = 3) +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        legend.position = "bottom",
        strip.text = element_text(size = 13),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 13),
        legend.text = element_text(size = 13)) +
  labs(color = "") +
  scale_color_manual(values = c(rainbow(22),"black")) +
#  ggtitle("Number of studies reporting at least one genome-wide significant association") +
  xlab("Chromosome") +
  ylab("Number of studies") +
  scale_shape_manual(values = c(4,16), guide = "none") +
  guides(color = guide_legend(nrow = 3, byrow = T))

pltdatsig$Number.cm <- pltdatsig$Number / chrstats$Mb[1:23]

# Figure 2
ggplot(pltdatsig, aes(x = Chr, y = Number.cm, color = Chr, shape = ChrX)) +
  geom_point() +
  theme_bw() +
  facet_wrap(Year ~., nrow = 3) +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        legend.position = "bottom",
        strip.text = element_text(size = 13),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 13),
        legend.text = element_text(size = 13)) +
  labs(color = "") +
  scale_color_manual(values = c(rainbow(22),"black")) +
#  ggtitle("Average number of studies reporting at least one genome-wide significant association per Mb") +
  xlab("Chromosome") +
  ylab("Number of studies / Mb") +
  scale_shape_manual(values = c(4,16), guide = "none") +
  guides(color = guide_legend(nrow = 3, byrow = T))

#pltjournal <- data.frame(Num = sort(table(gwassub_all$JOURNAL[gwassub_all$CHR_ID=="X"]),decreasing = T),
#                         Journal = names(sort(table(gwassub_all$JOURNAL[gwassub_all$CHR_ID=="X"]),decreasing = T)))
#ggplot(pltjournal[1:10,], aes(x = Num.Var1, y = Num.Freq, label = Num.Freq)) +
#  geom_bar(stat = "identity") +
#  geom_text(aes(vjust = -1)) +
#  ggtitle("Number of publications reporting at least one association on chrX") +
#  ylab("") +
#  xlab("Journal") +
#  theme_classic() +
#  theme(axis.title = element_text(size = 14),
#        axis.text = element_text(size = 13),
#        axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))

#pltjournalall <- data.frame(Num = sort(table(unique(gwassub_all[,c("PUBMEDID","JOURNAL")])$JOURNAL),decreasing = T),
#                            Journal = names(sort(table(unique(gwassub_all[,c("PUBMEDID","JOURNAL")])$JOURNAL),decreasing = T)))
#ggplot(pltjournalall[1:10,], aes(x = Num.Var1, y = Num.Freq, label = Num.Freq)) +
#  geom_bar(stat = "identity") +
#  geom_text(aes(vjust = -1)) +
#  ggtitle("Number of publications reporting at least one association") +
#  ylab("") +
#  xlab("Journal") +
#  theme_classic() +
#  theme(axis.title = element_text(size = 14),
#        axis.text = element_text(size = 13),
#        axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))

