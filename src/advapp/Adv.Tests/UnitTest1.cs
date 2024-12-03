using FluentAssertions;

namespace Adv.Tests;

public class Tests
{
    [SetUp]
    public void Setup()
    {
    }

    [Test]
    public void Test1()
    {
        int result = 1 + 2;
        result.Should().Be(3);
    }
}