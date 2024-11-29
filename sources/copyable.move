module book::copyable;
#[allow(unused_field)]
public struct Foo has copy,drop{
    value : u64
}

#[test]
public fun test_copy()
{
    let s1 = Foo { value : 1};
    let mut s2 = s1 ;
    s2.value = 2;
    std::debug::print(&s1);
    std::debug::print(&s2);
}