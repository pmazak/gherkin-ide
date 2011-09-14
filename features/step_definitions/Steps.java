import static org.junit.Assert.*;
import cuke4duke.annotation.I18n.EN.Given;
import cuke4duke.annotation.I18n.EN.Then;

@Test
public class Steps
{
    def a = 0
    def b = 0
    
	@Given("^a is two$")
	public void a_is_two()
	{
        a = 2
	}

    @Given("^b is two$")
	public void b_is_two()
	{
        b = 2
	}
    
    @Then("^a plus b equals four$")
	public void a_is_two()
	{
        assertEquals(4, a+b)
	}
}