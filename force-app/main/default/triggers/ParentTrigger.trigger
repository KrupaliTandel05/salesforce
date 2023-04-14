trigger ParentTrigger on Account (before insert , after  delete) {

    //fetching all the records of the account 
    List<Account> allRecord = [SELECT Id , Parent_Accounts__c ,ParentId FROM Account];

    //trigger new
    List<Account> tnew = Trigger.new ; 

    //trigger old 
    List<Account> told = Trigger.old ; 

    //link all the data to the map 
    Map<Id , Account > mapdata = new Map<Id , Account>();

    for(Account i  : allRecord){
        mapdata.put(i.Id, i);
    }
     
    // setting up the trigger 
    if(trigger.isInsert){
        ChildHandler.isInsertParent(mapdata, tnew);
    }
    else if(trigger.isDelete){
        
        List<Account> tobedelete = ChildHandler.tobeDeleted(mapdata, tnew);
        update tobedelete ; 
    }

}