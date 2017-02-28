「Rでトラッキングデータをいじる」 コード置き場
===
日本バイオロギング研究会会報No.1XX号に掲載された解析Tips「Rでトラッキングデータをいじる」に用いたサンプルコード集です。Sample codes for handling tracking data on R. Original article was posted in the JSBLS newsletter No. 1xx.
### このリポジトリについて
バイオロギング研究会会報記事「Rでトラッキングコードをいじる」を作成するにあたり、テスト用に作成したトラッキングコードの生成からggplot2を使った移動軌跡の描画、海洋環境データの読み込みと作図、統計解析用のコード等を記載しています。
このリポジトリに含まれている各Rコードの説明は以下の通り。
* maketrackingdata.r -----トラッキングデータ生成及び描画
* readSST.r       -----NOAAの[AVHRR-OI][a]からSSTをダウンロードし、ヒートマップ及びコンター図を作成
* extractSST.r -----maketrackingdata.rとreadSST.rで作成した水温データを組み合わせて、移動軌跡上の水温データを抽出して比較    
* kerneldens.r -----カーネル密度を地図上に描画

### 利用方法
各自でダウンロードし、お手持ちのデータに合わせて改変してご利用ください。
右上の緑ボタン「Clone or download」を押し「Download ZIP」をクリックすると
全ファイルがZIPファイルでダウンロードされます。gitを使ってる人は適宜cloneしてください。
利用にあたってはR base以外に追加パッケージ"plyr", "dplyr", "ggplot2", "R.utils", "raster",
"maps", "marmap"が必要です(Rのコンソール上でinstall.packages("パッケージ名")でインストール)。またRのコンソール上で直接[AVHRR-OI][a]からSSTをダウンロードするには、Windowsの場合
["wget for Windows"][b]などのツールのインストールおよび設定(参照<http://assimane.blog.so-net.ne.jp/2013-01-21>)が必要となりますのであらかじめご留意くださいませ(Macは不要…のはず)。

[a]: ftp://podaac-ftp.jpl.nasa.gov/allData/ghrsst/data/L4/GLOB/NCDC/AVHRR_OI/
[b]: http://gnuwin32.sourceforge.net/packages/wget.htm
