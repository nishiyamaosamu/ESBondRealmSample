[ 個人的な見解 ]

BondはViewModelからViewへの一方向のみで使うのはあり
（非同期でデータとってきたり、一部データを変更した時に、毎回updateメソッド呼ぶのは大変）

各ViewModel（tableのViewMode, tableCellのViewModel）はそれぞれに対応するファイル内（tableならviewController, tableCellならtableCellView)で操作すべき
（じゃないと対応関係がわからなくなる）

[ 各要素の役割 ]
Model:
 データの更新、realm, apiを叩く

ViewModel:
 データをViewに橋渡しする役
 Viewに表示する要素をattributeとして持つ
 Modelから引っ張ったデータをView用に加工したりとかする

View:
 ViewModelから受け取ったデータをただただ表示する
 場合によってはユーザーからの入力イベントを受け取って、ViewModelに渡す

[ 各イベントの伝搬 ]
Model => ViewModel
 #=> RealmのNotificationToken

ViewModel => View
 #=> Bond

View => ViewModel
 #=> イベント検知のdelegateメソッド内部でViewModelのメソッドを呼ぶ

ViewModel => Model
 #=> メソッド内でModelのメソッドを呼ぶ

※ View <=> Modelが直接やりとりすることを禁止する
