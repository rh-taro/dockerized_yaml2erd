# usage
## install docker
https://docs.docker.com/install/

## clone this repository
```
$ git clone git@github.com:rh-taro/dockerized_yaml2erd.git
```

## move to dockerized_yaml2erd directory
```
$ cd dockerized_yaml2erd
```

## start up docker 
```
$ docker-compose build
$ docker-compose up -d
```

## edit or create yaml
edit `app/yaml/table.yaml` or create new yaml

## exec rb script with default conf
```
$ docker-compose exec yaml2erd rails runner app/scripts/yaml_dump.rb app/yaml/table.yaml
```

## exec rb script with custom conf
```
$ docker-compose exec yaml2erd rails runner app/scripts/yaml_dump.rb app/yaml/table.yaml config/gv_conf.yaml
```
If you write in the config file you can change the setting

It is also possible to write only a part

## outputed file to
- `erd/table.png`
- `erd/table.dot`

# Sample
## [app/yaml/table.yaml](https://github.com/rh-taro/dockerized_yaml2erd/blob/01471477832562b7c15f182c5324f1e02de5d5f2/app/yaml/table.yaml)
```
groups:
  - name: ユーザ
    bgcolor: '#9cf5b7'
  - name: 投稿
    bgcolor: '#bcdbf7'

tables:
  User:
    columns:
      id:
        type: bigint(8)
        options:
          primary_key: true
          not_null: true
        logical_name: 主キー
      name:
        type: text
        options:
          not_null: true
          default: None Name
        logical_name: 名前
      created_at:
        type: datetime
        options:
          not_null: true
        logical_name: 作成日時
      updated_at:
        type: datetime
        options:
          not_null: true
        logical_name: 更新日時
    group: ユーザ
    relations:
      - has_many: Post
      - has_many: Favorite
    description: |-
      ユーザテーブル
  Post:
    columns:
      id:
        type: bigint(8)
        options:
          primary_key: true
          not_null: true
        logical_name: 主キー
      title:
        type: text
        options:
          not_null: true
        logical_name: タイトル
      body:
        type: text
        options:
          not_null: true
        logical_name: 本文
      created_at:
        type: datetime
        options:
          not_null: true
        logical_name: 作成日時
      updated_at:
        type: datetime
        options:
          not_null: true
        logical_name: 更新日時
    group: 投稿
    relations:
      - belongs_to: User
      - has_many: Comment
      - has_many: Favorite
    description: |-
      投稿テーブル
  Comment:
    columns:
      id:
        type: bigint(8)
        options:
          primary_key: true
          not_null: true
        logical_name: 主キー
      post_id:
        type: bigint(8)
        options:
          not_null: true
          foreign_key: true
        logical_name: 投稿id
      user_id:
        type: bigint(8)
        options:
          not_null: true
          foreign_key: true
        logical_name: ユーザid
      title:
        type: text
        options:
          not_null: true
        logical_name: タイトル
      body:
        type: text
        options:
          not_null: true
        logical_name: 本文
      created_at:
        type: datetime
        options:
          not_null: true
        logical_name: 作成日時
      updated_at:
        type: datetime
        options:
          not_null: true
        logical_name: 更新日時
    group: 投稿
    relations:
      - belongs_to: Post
      - belongs_to: User
    description: |-
      コメントテーブル
  Favorite:
    columns:
      id:
        type: bigint(8)
        options:
          primary_key: true
          not_null: true
        logical_name: 主キー
      post_id:
        type: bigint(8)
        options:
          not_null: true
          foreign_key: true
        logical_name: 投稿id
        description: |-
          user_idのユーザがお気に入りした投稿のid
      user_id:
        type: bigint(8)
        options:
          not_null: true
          foreign_key: true
        logical_name: ユーザid
      created_at:
        type: datetime
        options:
          not_null: true
        logical_name: 作成日時
      updated_at:
        type: datetime
        options:
          not_null: true
        logical_name: 更新日時
    relations:
      - belongs_to: Post
      - belongs_to: User
    description: |-
      お気に入りテーブル

```

## [erd/table.png](https://github.com/rh-taro/dockerized_yaml2erd/blob/67ce85e1b5ddb78968f107fad526ac3beec1bc73/erd/table.png)
![erd/table.png](https://github.com/rh-taro/dockerized_yaml2erd/blob/67ce85e1b5ddb78968f107fad526ac3beec1bc73/erd/table.png)

## [erd/table.dot](https://github.com/rh-taro/dockerized_yaml2erd/blob/67ce85e1b5ddb78968f107fad526ac3beec1bc73/erd/table.dot)
```
digraph G {
  subgraph cluster0 {
    shape="Mrecord";
    fontname="Noto Sans CJK JP Black";
    fontsize="120";
    label="ユーザ";
    bgcolor="#9cf5b7";
    node[shape="Mrecord",fontname="Noto Sans CJK JP Black",fontsize="50"];
    User;
  }
  subgraph cluster1 {
    shape="Mrecord";
    fontname="Noto Sans CJK JP Black";
    fontsize="120";
    label="投稿";
    bgcolor="#bcdbf7";
    node[shape="Mrecord",fontname="Noto Sans CJK JP Black",fontsize="50"];
    Post;
    Comment;
  }
  layout="dot";
  node[shape="Mrecord",fontname="Noto Sans CJK JP Black",fontsize="50"];
  User[label=<<table border='0' cellborder='1' cellpadding='8'><tr><td bgcolor='lightblue' colspan='8'>User</td></tr><tr><td bgcolor='lightblue'>物理名</td><td bgcolor='lightblue'>論理名</td><td bgcolor='lightblue'>型</td><td bgcolor='lightblue'>PK</td><td bgcolor='lightblue'>FK</td><td bgcolor='lightblue'>NOT_NULL</td><td bgcolor='lightblue'>DEFAULT</td><td bgcolor='lightblue'>説明</td></tr><tr><td bgcolor='white' align='left'>id</td><td bgcolor='white' align='left'>主キー</td><td bgcolor='white' align='left'>bigint(8)</td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='left'></td><td bgcolor='white' align='left'></td></tr><tr><td bgcolor='white' align='left'>name</td><td bgcolor='white' align='left'>名前</td><td bgcolor='white' align='left'>text</td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='left'>None Name</td><td bgcolor='white' align='left'></td></tr><tr><td bgcolor='white' align='left'>created_at</td><td bgcolor='white' align='left'>作成日時</td><td bgcolor='white' align='left'>datetime</td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='left'></td><td bgcolor='white' align='left'></td></tr><tr><td bgcolor='white' align='left'>updated_at</td><td bgcolor='white' align='left'>更新日時</td><td bgcolor='white' align='left'>datetime</td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='left'></td><td bgcolor='white' align='left'></td></tr><tr><td bgcolor='lightblue' colspan='8'>ユーザテーブル</td></tr></table>>];
  Post[label=<<table border='0' cellborder='1' cellpadding='8'><tr><td bgcolor='lightblue' colspan='8'>Post</td></tr><tr><td bgcolor='lightblue'>物理名</td><td bgcolor='lightblue'>論理名</td><td bgcolor='lightblue'>型</td><td bgcolor='lightblue'>PK</td><td bgcolor='lightblue'>FK</td><td bgcolor='lightblue'>NOT_NULL</td><td bgcolor='lightblue'>DEFAULT</td><td bgcolor='lightblue'>説明</td></tr><tr><td bgcolor='white' align='left'>id</td><td bgcolor='white' align='left'>主キー</td><td bgcolor='white' align='left'>bigint(8)</td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='left'></td><td bgcolor='white' align='left'></td></tr><tr><td bgcolor='white' align='left'>title</td><td bgcolor='white' align='left'>タイトル</td><td bgcolor='white' align='left'>text</td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='left'></td><td bgcolor='white' align='left'></td></tr><tr><td bgcolor='white' align='left'>body</td><td bgcolor='white' align='left'>本文</td><td bgcolor='white' align='left'>text</td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='left'></td><td bgcolor='white' align='left'></td></tr><tr><td bgcolor='white' align='left'>created_at</td><td bgcolor='white' align='left'>作成日時</td><td bgcolor='white' align='left'>datetime</td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='left'></td><td bgcolor='white' align='left'></td></tr><tr><td bgcolor='white' align='left'>updated_at</td><td bgcolor='white' align='left'>更新日時</td><td bgcolor='white' align='left'>datetime</td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='left'></td><td bgcolor='white' align='left'></td></tr><tr><td bgcolor='lightblue' colspan='8'>投稿テーブル</td></tr></table>>];
  Favorite[label=<<table border='0' cellborder='1' cellpadding='8'><tr><td bgcolor='lightblue' colspan='8'>Favorite</td></tr><tr><td bgcolor='lightblue'>物理名</td><td bgcolor='lightblue'>論理名</td><td bgcolor='lightblue'>型</td><td bgcolor='lightblue'>PK</td><td bgcolor='lightblue'>FK</td><td bgcolor='lightblue'>NOT_NULL</td><td bgcolor='lightblue'>DEFAULT</td><td bgcolor='lightblue'>説明</td></tr><tr><td bgcolor='white' align='left'>id</td><td bgcolor='white' align='left'>主キー</td><td bgcolor='white' align='left'>bigint(8)</td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='left'></td><td bgcolor='white' align='left'></td></tr><tr><td bgcolor='white' align='left'>post_id</td><td bgcolor='white' align='left'>投稿id</td><td bgcolor='white' align='left'>bigint(8)</td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='left'></td><td bgcolor='white' align='left'>user_idのユーザがお気に入りした投稿のid</td></tr><tr><td bgcolor='white' align='left'>user_id</td><td bgcolor='white' align='left'>ユーザid</td><td bgcolor='white' align='left'>bigint(8)</td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='left'></td><td bgcolor='white' align='left'></td></tr><tr><td bgcolor='white' align='left'>created_at</td><td bgcolor='white' align='left'>作成日時</td><td bgcolor='white' align='left'>datetime</td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='left'></td><td bgcolor='white' align='left'></td></tr><tr><td bgcolor='white' align='left'>updated_at</td><td bgcolor='white' align='left'>更新日時</td><td bgcolor='white' align='left'>datetime</td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='left'></td><td bgcolor='white' align='left'></td></tr><tr><td bgcolor='lightblue' colspan='8'>お気に入りテーブル</td></tr></table>>];
  Comment[label=<<table border='0' cellborder='1' cellpadding='8'><tr><td bgcolor='lightblue' colspan='8'>Comment</td></tr><tr><td bgcolor='lightblue'>物理名</td><td bgcolor='lightblue'>論理名</td><td bgcolor='lightblue'>型</td><td bgcolor='lightblue'>PK</td><td bgcolor='lightblue'>FK</td><td bgcolor='lightblue'>NOT_NULL</td><td bgcolor='lightblue'>DEFAULT</td><td bgcolor='lightblue'>説明</td></tr><tr><td bgcolor='white' align='left'>id</td><td bgcolor='white' align='left'>主キー</td><td bgcolor='white' align='left'>bigint(8)</td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='left'></td><td bgcolor='white' align='left'></td></tr><tr><td bgcolor='white' align='left'>post_id</td><td bgcolor='white' align='left'>投稿id</td><td bgcolor='white' align='left'>bigint(8)</td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='left'></td><td bgcolor='white' align='left'></td></tr><tr><td bgcolor='white' align='left'>user_id</td><td bgcolor='white' align='left'>ユーザid</td><td bgcolor='white' align='left'>bigint(8)</td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='left'></td><td bgcolor='white' align='left'></td></tr><tr><td bgcolor='white' align='left'>title</td><td bgcolor='white' align='left'>タイトル</td><td bgcolor='white' align='left'>text</td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='left'></td><td bgcolor='white' align='left'></td></tr><tr><td bgcolor='white' align='left'>body</td><td bgcolor='white' align='left'>本文</td><td bgcolor='white' align='left'>text</td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='left'></td><td bgcolor='white' align='left'></td></tr><tr><td bgcolor='white' align='left'>created_at</td><td bgcolor='white' align='left'>作成日時</td><td bgcolor='white' align='left'>datetime</td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='left'></td><td bgcolor='white' align='left'></td></tr><tr><td bgcolor='white' align='left'>updated_at</td><td bgcolor='white' align='left'>更新日時</td><td bgcolor='white' align='left'>datetime</td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'></td><td bgcolor='white' align='center'>✔︎</td><td bgcolor='white' align='left'></td><td bgcolor='white' align='left'></td></tr><tr><td bgcolor='lightblue' colspan='8'>コメントテーブル</td></tr></table>>];
  User -> Post[arrowhead="crow",arrowtail="tee",arrowsize="5",dir="both",minlen="5",penwidth="10"];
  User -> Favorite[arrowhead="crow",arrowtail="tee",arrowsize="5",dir="both",minlen="5",penwidth="10"];
  Post -> Comment[arrowhead="crow",arrowtail="tee",arrowsize="5",dir="both",minlen="5",penwidth="10"];
  Post -> Favorite[arrowhead="crow",arrowtail="tee",arrowsize="5",dir="both",minlen="5",penwidth="10"];
}
```

## show usable font
`$ docker-compose exec yaml2erd fc-list`
