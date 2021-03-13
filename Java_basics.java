//Arrays
int[] myIntArray = new int[3];
int[] myIntArray = {1,2,3};
int[] myIntArray = new int[]{1,2,3};
 
List<String> myIntList = new ArrayList<String>();
 

//sort array
Arrays.sort(myIntArray);

//Set remove duplicates on arrays
int end = myIntArray.length;
Set<Integer> noDuplicatesSet = new HashSet<Integer>();
for(int i = 0; i < end; i++){ 
	noDuplicatesSet.add(myIntArray[i]);
}

Object[] y = noDuplicatesSet.toArray();
for(int i=0;i<y.length;i++){
	System.out.println(y[i]);
}


//Map
HashMap<String,Integer> hm=new HashMap<String,Integer>();
Map<Long, Long> map = new HashMap<>();
map.put(n, map.getOrDefault(n, 0L) + 1);

//Iterate map 
mapIterator<Map.Entry<String, String>> itr = gfg.entrySet().iterator();
while(itr.hasNext())         { 
  Map.Entry<String, String> entry = itr.next();
  System.out.println("Key = " + entry.getKey() +", Value = " + entry.getValue());      
 } 

//Sort map
SortedMap map = new TreeMap(java.util.Collections.reverseOrder()); --> map in descending order

HashSet<Integer> nums = new HashSet<Integer>(); // faster than list 
 
LinkedList<String> myLinkedList = new LinkedList<String>();

// Add a node with data="First" to back of the (empty) list
myLinkedList.add("First"); 
System.out.println(myLinkedList); 

// Insert a node with data="Fifth" at index 2
myLinkedList.add(2, "Fifth"); 

// Print the list:
System.out.println(myLinkedList); 

//Compare objects
@Override public boolean equals(Object obj){
		if (obj == null) return false;
		if (obj == this) return true;
		
		return this.name == ((Player) obj).name;
		
	} 

//Compare objects to use in sort functions	

//The compareTo() method will return a negative int if called with a Person having a greater last name than this, 
//zero if the same last name, and positive otherwise
  public class Person implements Comparable<Person> {
    //...
 
    @Override
    public int compareTo(Person o) {
        return this.lastName.compareTo(o.lastName);
    }
}

 
