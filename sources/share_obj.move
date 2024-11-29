module book::share_a{
    public struct Foo has key{id : UID, value : u64 } 
    fun init(ctx:&mut TxContext){
        let foo = Foo{
            id : object::new(ctx),
            value : 1
        };
        sui::transfer::share_object(foo); //共享所有区
    }
    public fun get_value(foo : &Foo) : u64{
        foo.value
    }
}
module book::access_b{
    public fun visit(foo : &book::share_a::Foo){
        //std::debug::print(&foo.value); //foo对象属性是模块内私有的
        std::debug::print(&foo.get_value());
    }
}


