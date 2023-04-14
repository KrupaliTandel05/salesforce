public with sharing class ChildHandler {
   
    //inserting the parent records in the hierarchy
    public static void isInsertParent(  Map<Id , Account > mapdata ,  List<Account> tnew){
        for(Account acc : tnew){
            //fetching all the ids
            Id parentId = acc.ParentId;
            
            while(parentId != null){
                Account temp = mapdata.get(parentId) ; 
                Id tempId = temp.Id ; 

                if(acc.Parent_Accounts__c == null) {
                    acc.Parent_Accounts__c = (String)tempId + ',' ; 
                }
                else {
                    acc.Parent_Accounts__c += (String)tempId + ',';
                }

                parentId = temp.ParentId ; 
            }
        }
    }

    //Deleting the records parent records when the record is deleted 
    public static List<Account> tobeDeleted(Map<Id , Account > mapdata ,  List<Account> tnew){
  //list to be updated 
  List<Account> tobeUpdated = new List<Account>();
        for(Account acc : tnew){
            //fetching all the ids 
            Id selfId = acc.Id ;

            //fetching the child records
            Account record = mapdata.get(selfId);
            String childString = record.child__c ; 

            List<Id> childList = childString.split(',');
            
            //the records to be removed from the list is the id itself and the parent accounts
            
            String parentString = record.Parent_Accounts__c ;
            List<Id> parentList = parentString.split(',');
            parentList.add(selfId);

            
           

            //iterating in the child list to update the parent records
            for(Id  i : childList){
                //accessing the parent field
                Account  parenttoBeUpdatedId = mapdata.get(i);
                String parentTobeUpdated = parenttoBeUpdatedId.Parent_Accounts__c ;
                //deleting the records from the parent account
                for(Id k : parentList){
                     parentTobeUpdated = parentTobeUpdated.remove(k + ',');
                }
                parenttoBeUpdatedId.Parent_Accounts__c = parentTobeUpdated ; 
                tobeUpdated.add(parenttoBeUpdatedId);
                
            }
        

            
        }
        return tobeUpdated;
    }
}