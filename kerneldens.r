###　事前にmaketrackingdata.rでデータを作っておく必要あり
### カーネル密度を表示。stat_dinsity2dで可能。nの値を調整することで解像度を変えられる
pl7 <- ggplot(df3, aes(x=lon, y=lat)) + stat_density2d(aes(fill=..level..), geom="polygon", n=1000) +
  geom_polygon(data=mapdat, aes(x=long, y=lat,group=group)) + scale_fill_gradientn( colours=jet.colors(9))+
  coord_fixed(xlim=c(130,180), ylim=c(10,45)) + labs(x="Longitude", y="Latitude", fill="Proportion")
print(pl7)
