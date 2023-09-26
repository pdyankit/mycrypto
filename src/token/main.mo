import Principal "mo:base/Principal";
import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter"; 

actor Token {

  Debug.print("hello");
  
  var owner : Principal = Principal.fromText("h2rrn-3pw3f-fjpri-c5p3j-zdrhv-nyrqd-l5vhl-fm5ct-a6z3k-rgjd7-wqe"); 
  var totalSupply : Nat = 1000000000;
  var symbol : Text = "DANG";
  
  private stable var balanceEntries : [(Principal,Nat)] = [];

  var balances = HashMap.HashMap<Principal,Nat>(1,Principal.equal,Principal.hash);

  public query func balanceOf(who:Principal): async Nat {
    let balance : Nat = switch (balances.get(who)) {
        case null 0;
        case (?result) result;
    };
    return balance;
  };
  public query func getSymbol() : async Text {
    return symbol;
  };
  public shared(msg) func payOut(amountprov:Nat) : async Text {
     //Debug.print(debug_show(msg.caller));
     if(balances.get(msg.caller) == null) {
         let amount = amountprov;
        let result = await transfer(msg.caller,amount);
        return result;
     } else {
       return "Already Claimed";
     }
  };
  public shared(msg) func transfer(to:Principal,amount:Nat): async Text {
     let fromBalance = await balanceOf(msg.caller);
     if(fromBalance > amount) {
        let newFromBalance : Nat = fromBalance - amount;
        balances.put(msg.caller,newFromBalance);

        let toBalance = await balanceOf(to);
        let newToBalance = toBalance+amount;
        balances.put(to,newToBalance);
        return "success";
     } else {
     return "insufficient balance";
     }
  };

  system func preupgrade() {
      balanceEntries := Iter.toArray(balances.entries());
  };
  system func postupgrade() {
      balances := HashMap.fromIter<Principal,Nat>(balanceEntries.vals(),1,Principal.equal,Principal.hash);
      if(balances.size() < 1) {
        balances.put(owner,totalSupply);
      }
  };
  
};