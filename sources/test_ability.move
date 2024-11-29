#[test_only]
module book::ability{
    use std::debug::print;
    public struct IgnoreMe has drop{
        a:u32,
        b:u32
    }
    #[test]
    fun test_ignore(){
        let im = IgnoreMe{a:3,b:4};
        print(&im);
    }
    public struct NoDrop{ value :u64 }
    #[test]
    fun test_nodrop(){
        let no_drop = NoDrop{ value :34};
        print(&no_drop);
        let NoDrop{ value: _ } = no_drop;
    }

    fun useNoDrop(o : NoDrop ) : NoDrop{
        std::debug::print(&o);
        o
    }

    #[test]
    fun testUseNoDrop(){
        let o = NoDrop{value :4};
        let d = useNoDrop(o);
        NoDrop{value:_} = d;
    }


    public struct  Container {
        o : NoDrop,
    }

    public fun containNoDrop(o : NoDrop ) : Container{
        std::debug::print(&o);
        Container{
            o : o,
        }
    }


    public struct Copyable has copy{
        value :u64,
    }

    #[test]
    fun test_copy(){
        let c = Copyable{ value:33};
        let mut d = c ; //此时c对象拷贝给d
        d.value = 44;
        std::debug::print(&c);
        std::debug::print(&d);
        
        sui::test_utils::destroy(c);
        sui::test_utils::destroy(d);
    }   

    
    public struct Keyable has key{
        id : UID,
    }

    #[test]
    fun test_key(){
        let mut ctx = tx_context ::dummy();
        let k = Keyable{ id: object::new(&mut ctx)};
        std::debug::print(&k);
        transfer::transfer(k,ctx.sender());
    }


    public struct Storeable has store{
        value : u64,      
    }
    public struct Object1 has key{
        id: UID,
        value : Storeable,
    }
    #[test]
    fun test_storeable(){
        let mut  ctx = tx_context::dummy();
        let o = Object1 {
            id : object::new(&mut ctx),
            value:Storeable{ value:33},
        };
        std::debug::print(&o);
        transfer::transfer(o,ctx.sender());
    }

    public struct NonCopyable {
        value :u64,
    }

    #[test]
    fun test_non_copy(){
        let c = NonCopyable{ value:33};
        let d = c ;
        //std::debug::print(&c); //此时c对象已经被移动给d
        std::debug::print(&d);

       // sui::test_utils::destroy(c);
        sui::test_utils::destroy(d);
    }   

    use std::string::String;
    public struct Grandson has store{
        name : String,
    }
    public struct Child has store{
        name : String,
        child : Grandson,
    }
    public struct Parent has key{
        id: UID,
        child: Child,
    }
    #[test]
    fun  test_store_child(){
        let mut ctx = tx_context::dummy();
        let foo = Parent {
            id : object::new(&mut ctx),
            child: Child {name : b"one child".to_string(),
                          child: Grandson{name : b"a grandson".to_string()}}};
        std::debug::print(&foo);
        transfer::freeze_object(foo);
    }

}