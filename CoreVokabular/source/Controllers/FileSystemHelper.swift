//
//  FileSystemHelper.swift
//  CoreVokabular
//
//  Created by Borja Arias Drake on 03/06/2018.
//  Copyright © 2018 Borja Arias Drake. All rights reserved.
//

import Foundation

public class FileSystemHelper {
    
    public class func documentsDirectoryURL() -> URL {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return URL(fileURLWithPath: paths.first!, isDirectory: true)
    }
    
    public class func storeLinesIntoImportedFile(_ title : String?, lines : Array<String>, directoryName: String) -> (Bool, String)
    {
        // Crate the folder
        let folderCreated = FileSystemHelper.create(directoryName: directoryName)
        guard (folderCreated == true) else {
            return (false, "")
        }
        
        // Get the lines into file format
        let fileText = FileSystemHelper.textFileRepresentation(of: lines)
        
        // Generate the file name
        let fileName = FileSystemHelper.fileName(withTitle: title)
        
        // Save the file
        let documentsFolderURL = FileSystemHelper.documentsDirectoryURL()
        let importedFilesPath = documentsFolderURL.appendingPathComponent(directoryName).path
        let filePath = URL(fileURLWithPath: importedFilesPath).appendingPathComponent(fileName)
        FileManager.default.createFile(atPath: filePath.path, contents: fileText.data(using: String.Encoding.utf8, allowLossyConversion: false), attributes: nil)
        let success = FileManager.default.createFile(atPath: filePath.path, contents: fileText.data(using: String.Encoding.utf8, allowLossyConversion: false), attributes: nil)
        
        return (success, fileName)
    }
    
    @discardableResult
    public class func deleteContentsOf(directoryName: String) -> Bool
    {
        let documentsDirectoryURL = FileSystemHelper.documentsDirectoryURL()
        let importedFilesPath = documentsDirectoryURL.appendingPathComponent(directoryName).path
        let fileManager = FileManager.default
        
        var success = true
        
        do
        {
            try fileManager.removeItem(atPath: importedFilesPath)
        }
        catch {
            success = false
        }
        
        return success
    }
    
    
    public class func create(directoryName: String) -> Bool
    {
        let documentsDirectoryURL = FileSystemHelper.documentsDirectoryURL()
        let importedFilesPath = documentsDirectoryURL.appendingPathComponent(directoryName).path
        let fileManager = FileManager.default
        var isDirectory : ObjCBool = true
        let directoryExists = fileManager.fileExists(atPath: importedFilesPath, isDirectory: &isDirectory)
        
        if !directoryExists
        {
            do
            {
                try fileManager.createDirectory(atPath: importedFilesPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch
            {
                print("Failed to create directory. \(error)")
            }
        }
        
        return fileManager.fileExists(atPath: importedFilesPath, isDirectory: &isDirectory)
    }
    
    class func fileName(withTitle title: String?) -> String {
        let fileName :  String
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        if let name = title {
            fileName = "\(name).txt"
        } else {
            fileName = "imported\(String(describing: components.year))\(String(describing: components.month))\(String(describing: components.day))\(String(describing: components.hour))\(String(describing: components.minute))\(String(describing: components.second)).txt"
        }
        
        return fileName
    }
    
    class func textFileRepresentation(of lines: Array<String>) -> String {
        var fileText = ""
        let lastString = lines.last
        
        for item in lines
        {
            if item == lastString
            {
                fileText = fileText + item
            }
            else
            {
                fileText = fileText.appendingFormat("\(item)\n")
            }
        }
        
        return fileText
    }
}
