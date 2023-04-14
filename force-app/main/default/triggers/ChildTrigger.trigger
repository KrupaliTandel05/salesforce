trigger ChildTrigger on Account (after insert,before delete ,after update ) {
    List<Account> AllData = [Select Id, ParentId,child__c ,Parent_Accounts__c from Account];
    List<Account> Result = new List<Account>();
    map<Id,Account> mapData = new map<Id,Account>();
    List<Account> told = Trigger.old ; 
    List<Account> tnew = Trigger.new ;
    List<Account> totalResult = new List<Account>();
    Map<Id,Account> totalResultMap = new Map<Id,Account>();
    for(Account i: AllData){ 
        mapData.put(i.Id,i);
    }
    
    if(Trigger.isInsert){
  		totalResult = TriggerHandler.InsertChild(mapData , Result , tnew );
        
    }
    else if(Trigger.isDelete){        
        totalResult = TriggerHandler.deleteChild(mapData , Result , told);
    }
    else if(Trigger.isUpdate){
        totalResultMap = TriggerHandler.UpdateChild(mapData , Result , tnew, told);
        totalResult = totalResultMap.values();
    }
   		
    update totalResult;
}