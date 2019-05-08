# JPEraFormats プラグイン for Movable Type

Movable Type の[日付に関するテンプレートタグの format モディファイア](https://www.movabletype.jp/documentation/appendices/date-formats.html)で、和暦表示を可能にします。

具体的には下記の値を追加します。（日本語のみ）

* %EC
* %Ec
* %EY
* %Ey

## ダウンロード

* [バージョン 0.1 (2019/04/28)](https://github.com/movabletype/mt-plugin-jp-era-formats/releases/download/0.1/mt-plugin-jp-era-formats-0.1.zip)

## インストール

* ダウンロードした zip ファイルを展開します。
* 展開してできた `mt-plugin-jp-era-formats/plugins/JPEraFormats` ディレクトリを、 MT の plugins ディレクトリの中にコピーします。

## 使い方

### %EC

元号を表示します。

```
<$mt:Date ts="20190501123456" format="%EC" language="jp"$>
```

```
令和
```

### %Ec

和暦で日時を表示します。1年は元年と表示されます。

```
<$mt:Date ts="20190501123456" format="%Ec" language="jp"$>
```

```
令和元年05月01日 12時34分56秒
```

### %EY

和暦で年を表示します。元号と年表示を含みます。1年は元年と表示されます。

```
<$mt:Date ts="20190501123456" format="%EY" language="jp"$>
```

```
令和元年
```

### %Ey

和暦で年を表示します。元号と年表示を含みません。

```
<$mt:Date ts="20190501123456" format="%Ey" language="jp"$>
```

```
1
```

## 動作確認環境

* Movable Type 7
* Movable Type 6

## 制限事項

* 明治、大正、昭和、平成、令和の年号にのみ対応しています。
* スタティックパブリッシングにのみ対応しています。
* 出力が日本語の場合にのみ対応しています。
  * サイトの言語設定が日本語の場合
  * `language="jp"` の場合

## フィードバック

不具合・ご要望は GitHub リポジトリの Issues の方までご連絡ください。

https://github.com/movabletype/mt-plugin-jp-era-formats/issues

## ライセンス

MIT License

Copyright (c) 2019 Six Apart, Ltd.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
