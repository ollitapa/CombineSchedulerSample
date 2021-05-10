import SwiftUI
import WithCombineScheduler
import WithoutCombineScheduler

@main
struct CombineSchedulerSampleApp: App {
    var body: some Scene {
        WindowGroup {
            WithCombineScheduler.mainView
            //WithoutCombineScheduler.mainView
        }
    }
}
