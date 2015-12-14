import XCTest

@testable import Oahu

class EvaluatorTests: XCTestCase {
    func testShouldEvaluateGoogleURL() {
        let evaluator = OahuEvaluator(closure: {}, url: "www.google.com")

        XCTAssertTrue(evaluator.matchUrl("https://www.google.com"))
    }

    func testShouldNotEvaluateYahooURL() {
        let evaluator = OahuEvaluator(closure: {}, url: "www.google.com")

        XCTAssertFalse(evaluator.matchUrl("http://www.yahoo.com"))
    }

    func testShouldValidateEvaluatorClosureExecution() {
        let evaluator = OahuEvaluator(closure: {XCTAssertTrue(true)}, url: "www.google.com")
        
        evaluator.execute()
    }
}