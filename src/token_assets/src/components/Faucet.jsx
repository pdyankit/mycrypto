import React, { useCallback, useState } from "react";
import { token } from "../../../declarations/token";

function Faucet() {
 const [isDisabled,setDisable] = useState(false)
 const [buttonText ,setText] = useState("Gimme gimme");
 const [provamount,setprovamount] = useState("")
  async function handleClick(event) {
    setDisable(true);
    const amounttotransfer = Number(provamount);
    const result = await token.payOut(amounttotransfer);
    setText(result);
  }

  return (
    <div className="blue window">
      <h2>
        <span role="img" aria-label="tap emoji">
          🚰
        </span>
        Faucet
      </h2>
      <label>Get your free DAngela tokens here! Claim {provamount} DANG coins to your account.</label>
      <p>
      <input
          type="text"
          id="transfer-to-id"
          placeholder="Enter the Amount"
          value={provamount}
          onChange={(e)=> setprovamount(e.target.value)}
              />
      </p>
      <p className="trade-buttons">
        <button 
        id="btn-payout" 
        onClick={handleClick}
        disabled={isDisabled}
        >
          {buttonText}
        </button>
      </p>
    </div>
  );
}

export default Faucet;
