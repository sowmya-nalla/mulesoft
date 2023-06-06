%dw 2.0
/*Custom Dataweave Script by Anil -25-12-2020 */
output application/json
var Counter = 1
var TableFlag = (TableFlag = ''as String) -> TableFlag
---
{
	/*Check if Account status is active or inActive */
	C1: if ( vars.fetchAccNo[0].accountStatus as String == 'Active' ) {
		/* Check if Datbase atmpin is equal to payld the atmpin and display the results */
		C2: if ( vars.fetchAccNo[0].atmPin as String == vars.setPayload.atmPin as String and vars.fetchAccNo[0].wrongPin < 3 ) {
			outPayload1: "Your Total Balance as on " ++ now() as String ++ "is" ++ vars.fetchAccNo[0].totalBalance as Number default null
		} 
	           else 
	                /*Check ATM PIN with wrongPin,if cond is false then update the db accordingly */ 
	    C3: if ( vars.fetchAccNo[0].atmPin as String != vars.setPayload.atmPin as String and vars.fetchAccNo[0].wrongPin == 3 ) OP1: {
			outPayload2: "Maximum Attempts reached .Your Account:" ++ vars.fetchAccNo[0].custAccNum as String ++ "is
												temporarily blocked. Please reach nearest Branch." default null,
			/*update the DBa ccount status to Blocked*/
			L21: lookup('UpdateAccStatus',{
				fetchAccNo: vars.fetchAccNo
			},40000),
			updateTableFlag1: TableFlag('Y') as String default TableFlag()
		}
					   
		 	       else{
			C4: if ( vars.fetchAccNo[0].wrongPin < 3 ) {
				/*Increment the wrong pin by 1 Note: u can use Lookup function to call the flow */
				OP2: {
					L2: lookup('updateWrongPin', {
						fetchAccNo: vars.fetchAccNo
					} , 750000 ),
					updateTableFlag2: TableFlag('Y') as String default TableFlag(),
					outPayload3: "Login Attempt Failed attempts remaining:" ++ vars.fetchAccNo[0].wrongPin as Number default null
				}
			}
		 	           		      else
		 	           		      null
		}
	}
	     
	    else 
	    {
		outPayload4: "Your Account:" ++ vars.fetchAccNo[0].custAccNum as String ++"is temporarily blocked. Please reach nearest Branch."default null,
	/* L2: lookup('OutputPayload',{outpayload:"Your Account:"++ vars.fetchAccNo[0].custAccNum as String ++"is temporarily blocked. Please reach nearest Branch."default null}, 25000 as Number) */
	// This is the last line and written to avoid the bug that executes always.
	}
}



 	
