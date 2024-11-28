module book::obj_ref ;
use std::debug::print;
use std::string::{utf8};
public struct Foo has key{
    id: UID,
    value: u64,
}

fun init(ctx: &mut TxContext){
    let foo = Foo{
        id: object::new(ctx),
        value: 100,
    };
    // 独有所有权，存储在链上
    transfer::transfer(foo,ctx.sender());
}

// 引用传递，不转移所有权， foo 的拥有者可以调用
public fun use_ref(foo: &Foo,ctx: & TxContext) {
    print(&utf8(b"use_ref: sender,foo:"));
    print(&ctx.sender());
    print(foo);
}

// 转移所有权， 只能foo的拥有者能使用
entry fun use_obj(foo: Foo,to: address, ctx: & TxContext) {
    print(&utf8(b"use_ref: sender,foo:"));
    print(&ctx.sender());
    print(&foo);
    transfer::transfer(foo,to);
}

#[test_only] use sui::test_scenario::{Scenario,Self as test};
#[test_only] const ALICE : address = @0xa;
#[test_only]const BOB : address = @0xb;

#[test]
entry fun use_obj_test() {
    //因为对象id 需要多个交易使用，这里随便赋予初值
    let mut foo_id = object::id_from_address(@0x0);
    //1. 合约部署：  foo -> ALICE
    let mut scenario =  test::begin(ALICE);
    init(scenario.ctx());
    
    //2.第1个交易块   ALICE  usse_ref
    let effects = test::next_tx(&mut scenario, ALICE);
    {
        foo_id = effects.created()[0];
        //2.1  ALICE 使用引用 (调用时提供地， sui系统检查用户访问权限)  foo => ALICE
        let f1 = test::take_from_sender_by_id<Foo>(&scenario, foo_id);
        //2.2 使用引用
        use_ref(& f1,scenario.ctx());
        //2.3 返回给sener  , foo =>ALICE  (sui系统自动完成)
        test::return_to_sender(&scenario, f1);
    };

    //3 第1个交易块   ALICE  use_obj
    test::next_tx(&mut scenario, ALICE);
    {
        //3.1 使用对象  foo => f2
        let f2 = test::take_from_sender_by_id<Foo>(&scenario, foo_id);
        //3.2 f2 => shared ，函数调用期间被共享
        use_obj(f2,BOB,scenario.ctx());
        //3.3 此时对象所有权已经转移，f2 不需要系统处理
    };

    // 4 第3次交易， BOB use_ref
    test::next_tx(&mut scenario, BOB);
    {
        //4.1 BOB 使用引用
        let f3 = test::take_from_sender_by_id(&scenario, foo_id);
        use_ref(&f3,scenario.ctx());
        //4.2 返回给sender ，f3 => BOB
        test::return_to_sender(&scenario, f3);
    };
    //5. 结束
    test::end(scenario);
}
