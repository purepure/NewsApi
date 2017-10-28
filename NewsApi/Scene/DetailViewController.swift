//
//  DetailViewController.swift
//  NewsApi
//
//  Created by conga phucanh on 10/28/17.
//  Copyright © 2017 conga phucanh. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate  {
    @IBOutlet weak var webview : WKWebView!
    @IBOutlet weak var indicator : UIActivityIndicatorView!

    public var article : Article?
    func configureView() {
        self.title = article?.title
        loadArticle()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    func loadArticle(){
        webview.load(URLRequest(url: URL(string: (article?.url)!)!))
        webview.navigationDelegate = self
    }

    //MARK: Web delegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "Whoop", message: "Something went wrong!\nWould you like to Retry?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Nope", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.destructive, handler: { (action) in
            self.loadArticle()
        }))

        self.present(alert, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }

    func exit() {
        self.dismiss(animated: true, completion: nil)
    }
}

