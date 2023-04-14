import { LightningElement, api ,wire  } from 'lwc';
// import getAccount from '@salesforce/apex/ParentController.getAccount';
import PARENT_ID from '@salesforce/schema/Account.ParentId';
import ACC_ID from '@salesforce/schema/Account.Id';
import { updateRecord } from 'lightning/uiRecordApi';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getChilds from '@salesforce/apex/ChildController.getChilds';

export default class Practical16 extends LightningElement {
@api recordId ;
value = '';
accountOptions ;

@wire(getChilds , {recordId : '$recordId'})
accounts({error , data }){
    if(data){
        this.accountOptions = data.map(account => {return {label : account.Name , value : account.Id}}) 
    }
    else if(error){
        console.error(error);
    }
} //this will store the result of the apex 

get options(){
    return this.accountOptions;
}

handleChanges(event){
    this.value = event.detail.value ; 
}

handleSave(){
    const fields = {} ; 
    fields[PARENT_ID.fieldApiName] = this.value ; 
    fields[ACC_ID.fieldApiName] = this.recordId ; 

    const record = {fields};
    updateRecord(record)
    .then(()=>{
        this.showSuccess();
    })
    .catch(()=>{
        this.showError();
    })

 
}
showSuccess(){
    const event = new ShowToastEvent({
        title  : "Success" , 
        message : "changes made successfully",
        variant : "success",
    }) ;
    this.dispatchEvent(event);
}

showError(){
    const event = new ShowToastEvent({
        title  : "Failure" , 
        message : "changes not made successfully",
        variant : "error",
    }) ;
    this.dispatchEvent(event);
}
}

