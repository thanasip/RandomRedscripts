module ItemAdder

@addField(PlayerSystem)
private let m_playerItems: array<wref<gameItemData>>;

@addMethod(PlayerSystem)
public func PlayerHasItem(id: TweakDBID) -> Bool {
    for item in this.m_playerItems {
        if Equals(ItemID.GetTDBID(item.GetID()), id) {
            return true;
        }
    }

    return false;
}

@wrapMethod(PlayerSystem)
protected cb func OnGameRestored() {
    wrappedMethod();

    let items: array<TweakDBID> = [
        t"Items.money"
    ];

    let player = this.GetLocalPlayerControlledGameObject();
    let gi = player.GetGame();
    let ts = GameInstance.GetTransactionSystem(gi);
    ts.GetItemList(player, this.m_playerItems);

    for item in items {
        if !this.PlayerHasItem(item) && !Equals(item, t"Items.money") {
            ts.GiveItem(player, ItemID.FromTDBID(item), 1);
        } else if Equals(item, t"Items.money")  { //Is Money - add lots
            ts.GiveItem(player, ItemID.FromTDBID(item), 9999999);
        }
    }

    ArrayClear(this.m_playerItems);
}
