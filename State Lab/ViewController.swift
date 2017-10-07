//
//  ViewController.swift
//  State Lab
//
//  Created by David Boesen on 10/7/17.
//  Copyright © 2017 David Boesen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var label:UILabel!
	private var animate = false
	private var smiley:UIImage!
	private var smileyView:UIImageView!
	private var segmentedControl:UISegmentedControl!
	private var index = 0
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let bounds = view.bounds
		let labelFrame = CGRect(x:bounds.origin.x,
		                        y:bounds.midY - 50, width:bounds.size.width, height:100)
		label = UILabel(frame: labelFrame)
		label.font = UIFont(name: "Helvetica", size:70)
		label.text = "Bazinga!"
		label.textAlignment = NSTextAlignment.center
		label.backgroundColor = UIColor.clear
		view.addSubview(label)
		
		
		
		// smiley.png is 84 x 84
		let smileyFrame = CGRect(x:bounds.midX - 42,
		                         y:bounds.midY/2 - 42, width:84, height:84)
		smileyView = UIImageView(frame:smileyFrame)
		smileyView.contentMode = UIViewContentMode.center
		let smileyPath =
			Bundle.main.path(forResource: "smiley", ofType: "png")!
		smiley = UIImage(contentsOfFile: smileyPath)
		smileyView.image = smiley
		
		segmentedControl =
			UISegmentedControl(items: ["One","Two", "Three", "Four"])
		segmentedControl.frame = CGRect(x:bounds.origin.x + 20, y:50,
		                                width: bounds.size.width - 40, height: 30)
		segmentedControl.addTarget(self, action: #selector(self.selectionChanged(sender:)),
		                           for: .valueChanged)
		view.addSubview(segmentedControl)
		
		view.addSubview(smileyView)
		
		
		
		if let value = UserDefaults.standard.value(forKey: "index"){
			let selectedIndex = value as! Int
			
			segmentedControl.selectedSegmentIndex = selectedIndex
		}
		
	
		
		
		
		
		
		
		let center = NotificationCenter.default
		
		center.addObserver(self, selector: Selector(("applicationWillResignActive")),
		                   name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
		center.addObserver(self, selector: Selector(("applicationDidBecomeActive")),
		                   name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
		center.addObserver(self, selector: Selector(("applicationDidEnterBackground")),
		                   name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
		center.addObserver(self, selector: Selector(("applicationWillEnterForeground")),
		                   name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
		
		// rotateLabelDown();
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


	
	func rotateLabelDown() {
		UIView.animate(withDuration: 0.5, animations: {
			self.label.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
		},
		                           completion: {(Bool) -> Void in
									self.rotateLabelUp()
		}
		)
	}
	func rotateLabelUp() {
		UIView.animate(withDuration: 0.5, animations: {
			self.label.transform = CGAffineTransform(rotationAngle: 0)
		},
		                           completion: {(Bool) -> Void in
									if self.animate {
									   self.rotateLabelDown()
									}
		}
		)
	}
	
	
	
	func applicationWillResignActive() {
		print("VC animate false: \(#function)")
		animate = false
	}
	func applicationDidBecomeActive() {
		print("VC animate true: \(#function)")
		animate = true
		rotateLabelDown()
	}
	
	
	func applicationDidEnterBackground() {
		print("VC smiley nothing and save index: \(#function)")
		// self.smiley = nil;
		// self.smileyView.image = nil;
		UserDefaults.standard.set(self.index, forKey:"index")
		
		
		
		let app = UIApplication.shared
		var taskId = UIBackgroundTaskInvalid
		let id = app.beginBackgroundTask() {
			print("Background task ran out of time and was terminated.")
			app.endBackgroundTask(taskId)
		}
		taskId = id
		if taskId == UIBackgroundTaskInvalid {
			print("Failed to start background task!")
			return
		}
		
		let backgroundQueue = DispatchQueue.global(qos: .background)
		
		backgroundQueue.async {
				print("Starting background task with " +
					"\(app.backgroundTimeRemaining) seconds remaining")
				self.smiley = nil;
				self.smileyView.image = nil;
				// simulate a lengthy (25 seconds) procedure
				Thread.sleep(forTimeInterval: 25)
				print("Finishing background task with " +
					"\(app.backgroundTimeRemaining) seconds remaining")
				app.endBackgroundTask(taskId)
		}
		
	}
	func applicationWillEnterForeground() {
		print("VC be smiley: \(#function)")
		let smileyPath =
			Bundle.main.path(forResource: "smiley", ofType:"png")!
		smiley = UIImage(contentsOfFile: smileyPath)
		smileyView.image = smiley
	}
	
	
	func selectionChanged(sender:UISegmentedControl) {
		index = segmentedControl.selectedSegmentIndex;
	}
	
}

