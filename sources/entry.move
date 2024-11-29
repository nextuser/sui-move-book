module book::entry_demo {
    public struct Foo has key {
        id: UID,
        bar: u64,
    }
    /// entry 函数可以接受 `TxContext` 作为其最后一个参数，系统会自动将 `TxContext` 作为参数传入
    entry fun share(bar: u64, ctx: &mut TxContext) {
        transfer::share_object(Foo {
            id: object::new(ctx),
            bar,
        })
    }
    /// 参数foo 必须是当前交易块的输入，不能是之前交易的结果
    entry fun update(foo: &mut Foo, ctx: &TxContext) {
        foo.bar = tx_context::epoch(ctx);
    }
    /// entry 函数可以返回有 `drop` 的类型
    entry fun bar(foo: &Foo): u64 {
        foo.bar
    }
    /// 这个函数不能是 `entry` 因为返回的类型没有 `drop`
    public fun foo(ctx: &mut TxContext): Foo {
        Foo { id: object::new(ctx), bar: 0 }
    }
}