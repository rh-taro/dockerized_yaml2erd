# usage
- install docker
	- https://docs.docker.com/install/
- clone this repository
	- `$ git clone git@github.com:rh-taro/yaml2erd.git`
- move to yaml2erd directory
	- `$ cd yaml2erd`
- docker start
	- `$ docker-compose build`
	- `$ docker-compose up -d`
- edit table.yaml
	- `app/yaml/table.yaml`
- exec rb script
	- `$ docker-compose exec yaml2erd rails runner app/scripts/yaml_dump.rb app/yaml/table.yaml`
- output file to `erd/table.png` `erd/table.dot`

## [app/yaml/table.yaml](https://github.com/rh-taro/yaml2erd/blob/6a5a0f26ebdb775f0c1fd5b4c1b7ba629ca6b6c8/app/yaml/table.yaml)
```
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
    relations:
      - belongs_to: User
      - has_many: Favorite
    description: |-
      投稿テーブル
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

## [erd/table.png](https://github.com/rh-taro/yaml2erd/blob/b20d08eff80010cec2e1f5ff50464b92d42b2c38/erd/table.png)
![erd/table.png](https://github.com/rh-taro/yaml2erd/blob/b20d08eff80010cec2e1f5ff50464b92d42b2c38/erd/table.png)

## [erd/table.dot](https://github.com/rh-taro/yaml2erd/blob/b20d08eff80010cec2e1f5ff50464b92d42b2c38/erd/table.dot)
```
digraph G {
  layout="dot";
  node[shape="Mrecord",fontname="Noto Sans CJK JP Black",fontsize="50"];
  User[label=<<table border='0' cellborder='1' cellpadding='8'><tr><td bgcolor='lightblue' colspan='8'>User</td></tr><tr><td bgcolor='lightblue'>物理名</td><td bgcolor='lightblue'>論理名</td><td bgcolor='lightblue'>型</td><td bgcolor='lightblue'>PK</td><td bgcolor='lightblue'>FK</td><td bgcolor='lightblue'>NOT_NULL</td><td bgcolor='lightblue'>DEFAULT</td><td bgcolor='lightblue'>説明</td></tr><tr><td align='left'>id</td><td align='left'>主キー</td><td align='left'>bigint(8)</td><td align='center'>✔︎</td><td align='center'></td><td align='center'>✔︎</td><td align='left'></td><td align='left'></td></tr><tr><td align='left'>name</td><td align='left'>名前</td><td align='left'>text</td><td align='center'></td><td align='center'></td><td align='center'>✔︎</td><td align='left'>None Name</td><td align='left'></td></tr><tr><td align='left'>created_at</td><td align='left'>作成日時</td><td align='left'>datetime</td><td align='center'></td><td align='center'></td><td align='center'>✔︎</td><td align='left'></td><td align='left'></td></tr><tr><td align='left'>updated_at</td><td align='left'>更新日時</td><td align='left'>datetime</td><td align='center'></td><td align='center'></td><td align='center'>✔︎</td><td align='left'></td><td align='left'></td></tr><tr><td bgcolor='lightblue' colspan='8'>ユーザテーブル</td></tr></table>>];
  Post[label=<<table border='0' cellborder='1' cellpadding='8'><tr><td bgcolor='lightblue' colspan='8'>Post</td></tr><tr><td bgcolor='lightblue'>物理名</td><td bgcolor='lightblue'>論理名</td><td bgcolor='lightblue'>型</td><td bgcolor='lightblue'>PK</td><td bgcolor='lightblue'>FK</td><td bgcolor='lightblue'>NOT_NULL</td><td bgcolor='lightblue'>DEFAULT</td><td bgcolor='lightblue'>説明</td></tr><tr><td align='left'>id</td><td align='left'>主キー</td><td align='left'>bigint(8)</td><td align='center'>✔︎</td><td align='center'></td><td align='center'>✔︎</td><td align='left'></td><td align='left'></td></tr><tr><td align='left'>title</td><td align='left'>タイトル</td><td align='left'>text</td><td align='center'></td><td align='center'></td><td align='center'>✔︎</td><td align='left'></td><td align='left'></td></tr><tr><td align='left'>body</td><td align='left'>本文</td><td align='left'>text</td><td align='center'></td><td align='center'></td><td align='center'>✔︎</td><td align='left'></td><td align='left'></td></tr><tr><td align='left'>created_at</td><td align='left'>作成日時</td><td align='left'>datetime</td><td align='center'></td><td align='center'></td><td align='center'>✔︎</td><td align='left'></td><td align='left'></td></tr><tr><td align='left'>updated_at</td><td align='left'>更新日時</td><td align='left'>datetime</td><td align='center'></td><td align='center'></td><td align='center'>✔︎</td><td align='left'></td><td align='left'></td></tr><tr><td bgcolor='lightblue' colspan='8'>投稿テーブル</td></tr></table>>];
  Favorite[label=<<table border='0' cellborder='1' cellpadding='8'><tr><td bgcolor='lightblue' colspan='8'>Favorite</td></tr><tr><td bgcolor='lightblue'>物理名</td><td bgcolor='lightblue'>論理名</td><td bgcolor='lightblue'>型</td><td bgcolor='lightblue'>PK</td><td bgcolor='lightblue'>FK</td><td bgcolor='lightblue'>NOT_NULL</td><td bgcolor='lightblue'>DEFAULT</td><td bgcolor='lightblue'>説明</td></tr><tr><td align='left'>id</td><td align='left'>主キー</td><td align='left'>bigint(8)</td><td align='center'>✔︎</td><td align='center'></td><td align='center'>✔︎</td><td align='left'></td><td align='left'></td></tr><tr><td align='left'>post_id</td><td align='left'>投稿id</td><td align='left'>bigint(8)</td><td align='center'></td><td align='center'>✔︎</td><td align='center'>✔︎</td><td align='left'></td><td align='left'>user_idのユーザがお気に入りした投稿のid</td></tr><tr><td align='left'>user_id</td><td align='left'>ユーザid</td><td align='left'>bigint(8)</td><td align='center'></td><td align='center'>✔︎</td><td align='center'>✔︎</td><td align='left'></td><td align='left'></td></tr><tr><td align='left'>created_at</td><td align='left'>作成日時</td><td align='left'>datetime</td><td align='center'></td><td align='center'></td><td align='center'>✔︎</td><td align='left'></td><td align='left'></td></tr><tr><td align='left'>updated_at</td><td align='left'>更新日時</td><td align='left'>datetime</td><td align='center'></td><td align='center'></td><td align='center'>✔︎</td><td align='left'></td><td align='left'></td></tr><tr><td bgcolor='lightblue' colspan='8'>お気に入りテーブル</td></tr></table>>];
  User -> Post[arrowhead="crow",arrowtail="tee",arrowsize="5",dir="both",minlen="5",penwidth="10"];
  User -> Favorite[arrowhead="crow",arrowtail="tee",arrowsize="5",dir="both",minlen="5",penwidth="10"];
  Post -> Favorite[arrowhead="crow",arrowtail="tee",arrowsize="5",dir="both",minlen="5",penwidth="10"];
}
```

## show usable font
`$ docker-compose exec yaml2erd fc-list`
