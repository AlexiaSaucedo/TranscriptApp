//
//  CoreData.swift
//  AudioToText
//
//  Created by Alexia Fernanda Saucedo Romero on 26/01/25.
//

import CoreData

class CoreDataViewModel : ObservableObject {
    //static let shared = CoreDataController()
    let container: NSPersistentContainer
    @Published var savedEntities : [AudioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: "AudiosContainer")
        
        //Loads data
        container.loadPersistentStores{(description, error) in
            if let error = error {
                print("Error loading Core Data \(error)")
            }
        }
        fetchAudios()
    }
    
    //Get Audios
    func fetchAudios(){
        let request = NSFetchRequest<AudioEntity>(entityName: "AudioEntity")
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("CD: Error fetching. \(error)")
        }
        
    }
    
    //Add New Audio Path
    func addAudio(path: String){
        let newAudio = AudioEntity(context: container.viewContext)
        newAudio.title = ""
        newAudio.path = path
        saveData()
    }
    
    func saveData(){
        do {
            try container.viewContext.save()
            fetchAudios()
        } catch let error {
            print("CD: Error Saving. \(error)")
        }
    }
}
