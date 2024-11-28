module book::module_a{
    public struct Keyable has key{
        id : UID
    }
    public fun handle_keyable(keyable : Keyable,to : address){
        sui::transfer::transfer(keyable,to);
    }

    public fun destory(keyable : Keyable){
        let Keyable{ id } = keyable;
        object::delete(id);
    }
}

module book::module_b{
    public fun handle_keyable(keyable : book::module_a::Keyable,
                              _to : address)
    {
        //缺乏store 不能public_transfer
       // transfer::public_transfer(keyable, _to) ;  //缺乏store
        book::module_a::destory(keyable);
    }
}