//
//  tableViewController.swift
//  imagePicker
//
//  Created by Atul Bansal on 30/03/18.
//  Copyright © 2018 Atul Bansal. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class tableViewController: UITableViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var memes: [Meme]{return appDelegate.memes}
   
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "tableIdentifier") as! tableCell
        
        let tableData = memes[(indexPath as NSIndexPath).row]
        cell.tableLabel?.text = "\(tableData.topText)...\(tableData.bottomText)"
        cell.tableLabel?.textAlignment = .center
        cell.tableImageView?.image = tableData.memedImage
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailMeme = self.storyboard!.instantiateViewController(withIdentifier: "detailMeme") as! detailMemeVController
        detailMeme.meme = memes[(indexPath as NSIndexPath).row]
        navigationController!.pushViewController(detailMeme, animated: true)
    }
    @IBAction func newMeme(_ sender: Any) {
        
        let editor = storyboard!.instantiateViewController(withIdentifier: "newMeme")
        present(editor, animated: true, completion: nil)
        
    }
}
