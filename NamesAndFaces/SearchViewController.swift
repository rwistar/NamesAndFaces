//
//  SearchViewController.swift
//  TwoWayCommunication
//
//  Created by Allie Shuldman 2016 on 3/6/16.
//  Copyright © 2016 Allie Shuldman. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var dataArray = [Person]()
    
    var filteredArray = [Person]()
    
    var shouldShowSearchResults = false
    
    var id = String()
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        loadListOfEveryone()
        setUpSearchBar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpSearchBar() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
        shouldShowSearchResults = true
        tableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        if !shouldShowSearchResults
        {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        filteredArray = dataArray.filter({ (person) -> Bool in
            let personText: NSString = person.name
            
            return (personText.rangeOfString(searchString!, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        
        tableView.reloadData()
    }
    
    func loadListOfEveryone() {
        /*
        let pathToFile = NSBundle.mainBundle().pathForResource("everyone", ofType: "txt")
        
        if let path = pathToFile {
            
            var everyoneString = ""
            
            do {
                everyoneString = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            }
            catch
            {
                _ = error as NSError
            }
            
            let tempArray = everyoneString.componentsSeparatedByString("\n")
            
            for var i = 0; i < 31; i=i+2
            {
                print("\(i) \(i+31)")
                let p = Person(name: tempArray[i], id: tempArray[i + 1])
                dataArray.append(p)
            }
            
            tableView.reloadData()
        }
         */
        let url = NSURL(string: "http://namesandfaces.hotchkiss.org/search.txt")
        
        var everyoneString : NSString = ""
        
        do
        {
            everyoneString = try NSString(contentsOfURL: url!, usedEncoding: nil)
        }
        catch
        {
            _ = error as NSError
        }
        let tempArray = everyoneString.componentsSeparatedByString("\n")
        
        for var i = 0; i < 50; i = i + 2
        {
            print("\(i) \(i+1)")
            let p = Person(name: tempArray[i], id: tempArray[i + 1])
            dataArray.append(p)
        }
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults
        {
            return filteredArray.count
        }
        else
        {
            return dataArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if shouldShowSearchResults
        {
            cell.textLabel?.text = filteredArray[indexPath.row].name
        }
        else
        {
            cell.textLabel?.text = dataArray[indexPath.row].name
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if shouldShowSearchResults
        {
            id = filteredArray[indexPath.row].id
            print(id)
        }
        else
        {
            id = dataArray[indexPath.row].id
            print(id)
        }
        
        performSegueWithIdentifier("goToSingleFromSearch", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToSingleFromSearch"
        {
            searchController.active = false
            let destination = segue.destinationViewController as! SingleViewViewController
            //destination.urlToLoad = NSURL(string: "http://namesandfaces.hotchkiss.org/single.php?id=" + "\(id)")
            let urlString = "http://namesandfaces.hotchkiss.org/dbsingle.php?id=" + "\(id)"
            print(urlString)
            
            let urlEncodedString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            let url = NSURL(string: urlEncodedString!)!
            print(url)
            
            destination.urlToLoad = url
        }
    }
    
    
    /*
 
     if let rangeOfZero = text.rangeOfString("0",
     options: NSStringCompareOptions.BackwardsSearch) {
     // Found a zero, get the following text
     let suffix = String(text.characters.suffixFrom(rangeOfZero.endIndex)) // "984"
     }
     
     */
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
