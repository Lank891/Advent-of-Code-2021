namespace Program
{
    class State
    {
        public int Depth { get; set; } = 0;
        public int HorizontalPosition { get; set; } = 0;

        public int Aim { get; set; } = 0;
    }

    abstract class Command
    {
        protected int _argument;

        protected Command(int argument) { _argument = argument; }

        public abstract void ExecutePart1(State state);

        public abstract void ExecutePart2(State state);

        public static Command CreateCommand(string commandName, int commandArgument) => commandName switch
        {
            "forward" => new CommandForward(commandArgument),
            "down" => new CommandDown(commandArgument),
            "up" => new CommandUp(commandArgument),
            _ => throw new Exception("Unknown command"),
        };
    }

    class CommandForward : Command
    {
        public CommandForward(int argument) : base(argument) { }

        public override void ExecutePart1(State state)
        {
            state.HorizontalPosition += _argument;
        }

        public override void ExecutePart2(State state)
        {
            state.HorizontalPosition += _argument;
            state.Depth += state.Aim * _argument;
        }
    }

    class CommandUp : Command
    {
        public CommandUp(int argument) : base(argument) { }

        public override void ExecutePart1(State state)
        {
            state.Depth -= _argument;
        }

        public override void ExecutePart2(State state)
        {
            state.Aim -= _argument;
        }
    }

    class CommandDown : Command
    {
        public CommandDown(int argument) : base(argument) { }

        public override void ExecutePart1(State state)
        {
            state.Depth += _argument;
        }

        public override void ExecutePart2(State state)
        {
            state.Aim += _argument;
        }
    }

    class Program
    {
        public static void Main()
        {
            IEnumerable<string>? lines = File.ReadLines("./input.txt");
            var commands = lines
                .Select(line => line.Split(null))
                .Select(parts => (command: parts[0], argument: Int32.Parse(parts[1])))
                .Select(parts => Command.CreateCommand(parts.command, parts.argument));

            // Part 1
            var state = new State();

            foreach(var command in commands)
            {
                command.ExecutePart1(state);
            }

            Console.WriteLine($"Part 1: {state.Depth * state.HorizontalPosition}");

            // Part 2
            var state2 = new State();

            foreach (var command in commands)
            {
                command.ExecutePart2(state2);
            }

            Console.WriteLine($"Part 2: {state2.Depth * state2.HorizontalPosition}");
        }
    }
}