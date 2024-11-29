module book::ref_assign;
public struct Foo has copy,drop{
    value : u64
}

#[test]
public fun test_copy()
{
    let mut s1 = Foo { value : 1};
    let s2 = &mut s1 ;
    s2.value = 2;
    std::debug::print(s2);
    std::debug::print(&s1);
}