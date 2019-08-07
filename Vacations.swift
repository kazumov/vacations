//
//  Vacations.swift
//  vacations
//
//  Created by Ruben R. Kazumov on 8/7/19.
//  Copyright © 2019 Ruben R. Kazumov. All rights reserved.
//

import Foundation

/// The application
///
/// Starts and stops routing to the youtube and roblox servers by editing
/// the `hosts` file.
class Vacations {
    
    /// List of command line suffixes for the help obtaining
    let helpCommands:[String] = "-? -help -what".components(separatedBy: " ")
    
    /// List of command line suffixes for the service start
    let startCommands:[String] = "-start -come -welcome -ok -go -begin -yes".components(separatedBy: " ")
    
    /// List of command line suffixes for the service stop
    let stopCommands:[String] = "-bye -stop -over -end -nomore -finish -enough -no".components(separatedBy: " ")
    
    /// Common hosts file header
    let header:String = """
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1    localhost
255.255.255.255    broadcasthost
::1             localhost
"""
    
    /// Lists of the "toxic" hosts
    let hostsList:[String] = ["youtube.com", "youtu.be", "roblox.com"]
    // TODO: Read the list of hosts from a file
    
    /// Lists of the re-routing IP addresses
    let stopIP:[String] = ["0.0.0.0", "127.0.0.1"]
    
    /// List of the re-routing IP version 6 addreses
    let stopIPv6:[String] = ["fe80::1%lo0"]
    
    /// The hosts file URL
    let hostsFileURL:URL = URL.init(fileURLWithPath: "/etc/hosts")
    
    /// Starts the application
    func run(_ argumentsList: [String]){
        
        // at least one suffix expected
        if argumentsList.count < 2 || helpCommands.contains(argumentsList[1]){
            print(help())
            exit(0)
        }
        
        if startCommands.contains(argumentsList[1]) {
            // TODO: start the service
            print("The service started. Have a nice vacation!")
        }
        
        if stopCommands.contains(argumentsList[1]) {
            // TODO: stop the service
            print("The service stopped. Have a nice one!")
        }
        
        
    }
}

extension Vacations {
    
    /// Composes the content of the hosts file with the hosts blocks
    /// - Returns: Content of the hosts file
    func stopContent() -> String {
        
        var body:String = self.header
        
        for host in self.hostsList{
            
            for ip in self.stopIP + self.stopIPv6{
                
                body = body + "\(ip)\t\t\t\(host)\n"
                
                body = body + "\(ip)\t\t\twww.\(host)\n"
                
            }
            
        }
        
        return(body)
    }
    
    
    /// Composes the content of hosts file without any blocks
    /// - Returns: Common header of the hosts file as a content of the file
    func startContent() -> String {
        return(self.header)
    }
    
    /// Stops the service
    func stop(){
        self.writeHostFile(self.stopContent())
    }
    
    /// Starts the service
    func start(){
        self.writeHostFile(self.startContent())
    }
    
    /// Rewrites the hosts file with the content
    ///
    /// - parameters:
    ///   - content: The full content the hosts file
    func writeHostFile(_ content:String){
        do {
            try content.write(to: self.hostsFileURL, atomically: false, encoding: .utf8)
        } catch {
            print("ERROR: Can't rewrite hosts file.")
            exit(1)
        }
        print("The hosts file updated.")
    }
}

extension Vacations {
    
    /// Prints help content to the application
    func help() -> String {
        let content:String = """
    Runs and stops routing service to hosts: \(self.hostsList.joined(separator: ", ")) by re-writing `/etc/hosts` file.
    Usage: vacations [OPTION]
    Example: vacations -nomore
    
    The list of possible options:
    For the help:
    \t\(self.helpCommands.joined(separator: "\n\t"))
    Stop the service:
    \t\(self.stopCommands.joined(separator: "\n\t"))
    Start the service:
    \t\(self.startCommands.joined(separator: "\n\t"))
    """
        return(content)
    }
}
