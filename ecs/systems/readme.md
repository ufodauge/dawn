# System functions

Entity を変更するためのコールバック関数として、System が用意されている。
System は以下のように、少なくとも一つのメソッドを実装したテーブルである。

```lua
-- system.update
function system:update(dt)
    ...
end
```

他にも以下のようなコールバック関数が用意されている。

* `system:filter(entity)`
  * システムが Entity を使用するなら true を返す関数。定義されていない場合はどの Entity も操作されない。
* `system:onAdd/Remove(entity)`
  * Entity が追加/除去されたときに呼ばれる。
* `system:onModify(entity)`
  * Entity が追加・除去されたときに呼ばれる。
* `system:onAddTo/RemoveFromWorld(entity)`
  * System が追加/除去されたときに呼ばれる。
* `system:pre/postWrap(entity)`
  * world.update に先んじて/後から呼ばれる。
    postWrap は entity を逆から走査する。


For Filters, it is convenient to use tiny.requireAll or tiny.requireAny, but one can write their own filters as well. Set the Filter of a System like so:

system.filter = tiny.requireAll("a", "b", "c")
or

function system:filter(entity)
    return entity.myRequiredComponentName ~= nil
end
All Systems also have a few important fields that are initialized when the system is added to the World. A few are important, and few should be less commonly used.

The world field points to the World that the System belongs to. Useful for adding and removing Entities from the world dynamically via the System.
The active flag is whether or not the System is updated automatically. Inactive Systems should be updated manually or not at all via system:update(dt). Defaults to true.
The entities field is an ordered list of Entities in the System. This list can be used to quickly iterate through all Entities in a System.
The interval field is an optional field that makes Systems update at certain intervals using buffered time, regardless of World update frequency. For example, to make a System update once a second, set the System's interval to 1.
The index field is the System's index in the World. Lower indexed Systems are processed before higher indices. The index is a read only field; to set the index, use tiny.setSystemIndex(world, system).
The indices field is a table of Entity keys to their indices in the entities list. Most Systems can ignore this.
The modified flag is an indicator if the System has been modified in the last update. If so, the onModify callback will be called on the System in the next update, if it has one. This is usually managed by tiny-ecs, so users should mostly ignore this, too.
There is another option to (hopefully) increase performance in systems that have items added to or removed from them often, and have lots of entities in them. Setting the nocache field of the system might improve performance. It is still experimental. There are some restriction to systems without caching, however.

There is no entities table.
Callbacks such onAdd, onRemove, and onModify will never be called
Noncached systems cannot be sorted (There is no entities list to sort).