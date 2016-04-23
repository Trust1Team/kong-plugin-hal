describe("Body Filter Test Suite", function()
	local filter	

	setup(function()
		filter = require "body_filter"
	end)

	teardown(function()
		filter = nil
	end)

	it("Test with upstream URL nil", function()
		local lhs = "{ \"url\": \"http:\\/\\/upstream.com\" }"
		local rhs = filter.execute(lhs, nil, "http://downstream.com")

		assert.same(lhs, rhs)
	end)

        it("Test with downstream URL nil", function()
                local lhs = "{ \"url\": \"http:\\/\\/upstream.com\" }"
                local rhs = filter.execute(lhs, "http://upstream.com", nil)

                assert.same(lhs, rhs)
        end)

        it("Test with URL present in data", function()
		local data = "{ \"url\": \"http:\\/\\/upstream.com\" }"

		local lhs = filter.execute(data, "http://upstream.com", "http://downstream.com")
		local rhs = "{\"url\":\"http:\\/\\/downstream.com\"}"

                assert.same(lhs, rhs)
        end)

        it("Test with partially escaped URL present in data", function()
                local data = "{ \"url\": \"http:/\\/upstream.com\" }"

                local lhs = filter.execute(data, "http://upstream.com", "http://downstream.com")
                local rhs = "{\"url\":\"http:\\/\\/downstream.com\"}"

                assert.same(lhs, rhs)
        end)

        it("Test with unescaped URL present in data", function()
                local data = "{ \"url\": \"http://upstream.com\" }"

                local lhs = filter.execute(data, "http://upstream.com", "http://downstream.com")
                local rhs = "{\"url\":\"http:\\/\\/downstream.com\"}"

                assert.same(lhs, rhs)
        end)

        it("Test with invalid JSON data", function()
                local data = "invalid"

                local lhs = filter.execute(data, "http://upstream.com", "http://downstream.com")
                local rhs = "invalid"

                assert.same(lhs, rhs)
        end)

        it("Test with URL present multiple times in data", function()
                local data = "{ \"header\": { \"url\": \"http:\\/\\/upstream.com\", \"body\": { \"url\": \"http:\\/\\/upstream.com\" }  } }"

                local lhs = filter.execute(data, "http://upstream.com", "http://downstream.com")
                local rhs = "{\"header\":{\"url\":\"http:\\/\\/downstream.com\",\"body\":{\"url\":\"http:\\/\\/downstream.com\"}}}"

                assert.same(lhs, rhs)
        end)

        it("Test with upstream URL ending on slash", function()
                local data = "{ \"url\": \"http:\\/\\/upstream.com\" }"

                local lhs = filter.execute(data, "http://upstream.com/", "http://downstream.com")
                local rhs = "{\"url\":\"http:\\/\\/downstream.com\"}"

                assert.same(lhs, rhs)
        end)

        it("Test with downstream URL ending on slash", function()
                local data = "{ \"url\": \"http:\\/\\/upstream.com\" }"

                local lhs = filter.execute(data, "http://upstream.com", "http://downstream.com/")
                local rhs = "{\"url\":\"http:\\/\\/downstream.com\"}"

                assert.same(lhs, rhs)
        end)

        it("Test with upstream and downstream URL ending on slash", function()
                local data = "{ \"url\": \"http:\\/\\/upstream.com\" }"

                local lhs = filter.execute(data, "http://upstream.com/", "http://downstream.com/")
                local rhs = "{\"url\":\"http:\\/\\/downstream.com\"}"

                assert.same(lhs, rhs)
        end)

        it("Test with URL that has an extra path", function()
                local data = "{ \"url\": \"http:\\/\\/upstream.com\\/foo\\/bar\" }"

                local lhs = filter.execute(data, "http://upstream.com/", "http://downstream.com/")
                local rhs = "{\"url\":\"http:\\/\\/downstream.com\\/foo\\/bar\"}"

                assert.same(lhs, rhs)
        end)

        it("Test with upstream URL that has a question mark", function()
                local data = "{ \"url\": \"http:\\/\\/upstream.com\\/?\\/foo\\/bar\" }"

                local lhs = filter.execute(data, "http://upstream.com/?", "http://downstream.com/")
                local rhs = "{\"url\":\"http:\\/\\/downstream.com\\/foo\\/bar\"}"

                assert.same(lhs, rhs)
        end)

        it("Test with downstream URL that has a question mark", function()
                local data = "{ \"url\": \"http:\\/\\/upstream.com\\/foo\\/bar\" }"

                local lhs = filter.execute(data, "http://upstream.com", "http://downstream.com/?")
                local rhs = "{\"url\":\"http:\\/\\/downstream.com\\/?\\/foo\\/bar\"}"

                assert.same(lhs, rhs)
        end)

        it("Test with URL array present in data", function()
                local data = "[ { \"url\": \"http:\\/\\/upstream.com\\/foo\" }, { \"url\": \"http:\\/\\/upstream.com\\/bar\" } ]"

                local lhs = filter.execute(data, "http://upstream.com", "http://downstream.com")
                local rhs = "[{\"url\":\"http:\\/\\/downstream.com\\/foo\"},{\"url\":\"http:\\/\\/downstream.com\\/bar\"}]"

                assert.same(lhs, rhs)
        end)
end)
