//
//  ViewController.swift
//  WantediOS
//
//  Created by 소하 on 2023/02/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imgViewList: [UIImageView]!
    @IBOutlet var btnList: [UIButton]!
    @IBOutlet var progressList: [UIProgressView]!
    @IBOutlet weak var btnAllLoad: UIButton!
    
    private var urlList:[String] = [
        "https://images.unsplash.com/reserve/bOvf94dPRxWu0u3QsPjF_tree.jpg?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8JUVEJTkyJThEJUVBJUIyJUJEfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60",
        "https://images.unsplash.com/photo-1454372182658-c712e4c5a1db?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8JUVEJTkyJThEJUVBJUIyJUJEfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60",
        "https://images.unsplash.com/photo-1494783367193-149034c05e8f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8JUVEJTkyJThEJUVBJUIyJUJEfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60",
        "https://images.unsplash.com/photo-1504714146340-959ca07e1f38?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8JUVEJTkyJThEJUVBJUIyJUJEfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60",
        "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fCVFRCU5MiU4RCVFQSVCMiVCRHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60"
    ]
    private var isAll:Bool = false
    private var index:Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    // UI Setting
    private func setUI() {
        for (i, imgView) in imgViewList.enumerated() {
            imgView.tag = i
            imgView.tintColor = .black
            imgView.image = UIImage(systemName: "photo")
        }
        for (i, btn) in btnList.enumerated() {
            btn.tag = i
            btn.setTitle("Load", for: .normal)
        }
        btnAllLoad.setTitle("Load All Images", for: .normal)
        for (i, progressView) in progressList.enumerated() {
            progressView.tag = i
            progressView.progress = 0
        }
    }
    // 이미지 로드
    private func loadImage() {
        resetUI()
        guard let url = URL(string: urlList[index]) else { return }
        let config = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        session.downloadTask(with: url).resume()
    }
    // 로드 전 이미지 및 로딩바 초기화
    private func resetUI() {
        let imgView = imgViewList[index]
        let progressView = progressList[index]
        imgView.image = UIImage(systemName: "photo")
        progressView.progress = 0
    }
}

extension ViewController : URLSessionDelegate, URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let byteFormatter = ByteCountFormatter()
        byteFormatter.allowedUnits = [.useKB, .useMB]
        //
        let written = byteFormatter.string(fromByteCount: totalBytesWritten)
        let expected = byteFormatter.string(fromByteCount: totalBytesExpectedToWrite)
        //
        let progressView = progressList[index]
        DispatchQueue.main.async {
            progressView.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let progressView = progressList[index]
        let imgView = imgViewList[index]
        if let data = try? Data(contentsOf: location), let image = UIImage(data: data) {
            DispatchQueue.main.async { [self] in
                imgView.image = image
                progressView.progress = 1
                if isAll && index < 4 {
                    index += 1
                    loadImage()
                } else {
                    isAll = false
                }
            }
        } else {
            progressView.progress = 0
        }
    }
}

extension ViewController {
    @IBAction func clickLoad(_ sender:UIButton) {
        index = sender.tag
        loadImage()
    }
    
    @IBAction func clickAllLoad(_ sender:Any) {
        index = 0
        isAll = true
        loadImage()
    }
}

