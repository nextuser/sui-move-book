module book::obj_area{
    
    public struct Foo has drop {value : u64  }
    #[allow(unused_variable)]
    public fun get_value_ref() : &Foo{
        let foo = Foo{
            value : 100
        } ;
        abort 
        //&foo
    }
}

