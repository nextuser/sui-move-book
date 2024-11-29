module book::no_copy;
public struct Foo has drop{
    value : u64
}

public fun test_move(){
    let s1 = Foo{ value :1};
    let s2 = s1;
    std::debug::print(&s2);
    //std::debug::print(&s1);
} 
