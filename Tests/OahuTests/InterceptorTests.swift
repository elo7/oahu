import XCTest

@testable import Oahu

class InterceptorTests: XCTestCase {
    var interceptor: Interceptor!

    override func setUp() {
        interceptor = Interceptor(evaluators: [
            OahuEvaluator(url: "www.bing.com"){},
            OahuEvaluator(url: "www.google.com"){},
            OahuEvaluator(url: "www.yahoo.com"){}
            ])
    }

    func testShouldValidateRemoveEvaluator() {
        XCTAssertTrue(interceptor.getEvaluators().count == 3)

        interceptor.removeEvaluatorForUrl(url: "www.bing.com")
        XCTAssertTrue(interceptor.getEvaluators().count == 2)
    }

    func testShouldRemoveAllBingEvaluators() {
        interceptor.add(evaluator: OahuEvaluator(url: "www.bing.com"){})
        XCTAssertTrue(interceptor.getEvaluators().count == 4)

        interceptor.removeEvaluatorForUrl(url: "www.bing.com")
        XCTAssertTrue(interceptor.getEvaluators().count == 2)
        XCTAssertFalse(interceptor.executeFirst("http://www.bing.com"))
    }

    func testShouldNotExecuteEvaluatorFromInterceptor() {
        interceptor.removeEvaluatorForUrl(url: "www.bing.com")

        XCTAssertFalse(interceptor.executeFirst("http://www.bing.com"))
    }

    func testShouldValidateAddEvaluator() {
        let interceptor = Interceptor(evaluators: [])
        XCTAssertTrue(interceptor.getEvaluators().count == 0)

        interceptor.add(evaluator: OahuEvaluator(url: "www.google.com"){})
        XCTAssertTrue(interceptor.getEvaluators().count == 1)
    }

    func testShouldExecuteEvaluatorFromInterceptor() {
        XCTAssertTrue(interceptor.executeFirst("http://www.bing.com"))
    }

    func testShouldExecuteFirstEvaluatorFromInterceptor() {
        XCTAssertTrue(interceptor.executeFirst("https://www.google.com"))
    }
}
