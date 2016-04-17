var JobsList = React.createClass({
  render: function() {
    var JobsNodes = this.props.data.map(function(job) {
      return (
        <tr key={job.id}>
          <td>{job.title}</td>
          <td>{job.description}</td>
          <td>{job.score}</td>
          <td>{job.company}</td>
        </tr>
      );
    });
    return (
      <tbody>
        {JobsNodes}
      </tbody>
    );
  }
});
var tableStyle = {
  width: '100%'
}
var JobsTable = React.createClass({

  render: function(){ return (
    <table className= "table table-striped table-bordered table-condensed" style ={tableStyle} >
      <thead>
        <tr>
          <th>Title</th>
          <th>Description</th>
          <th>Score</th>
          <th>Company</th>
        </tr>
      </thead>

        <JobsList data = {this.props.data}/>
    </table>
  )}
});

var JobsBox = React.createClass({
  render: function() {
    return (
      <div className="JobsBox">
        <JobsTable data = {this.props.jobs} />
      </div>
    );
  }
});

var FilterableProductTable = React.createClass({
  getInitialState: function() {
    return {
      filterText: ''
    };
  },

  render: function() {
    return (
      <div>
        <SearchBar
          filterText={this.state.filterText}
          inStockOnly={this.state.inStockOnly}
        />
        <ProductTable
          products={this.props.products}
          filterText={this.state.filterText}
          inStockOnly={this.state.inStockOnly}
        />
      </div>
    );
  }
});

var SearchBar = React.createClass({
  render: function() {
    return (
      <form>
        <input type="text" placeholder="Job Title" />
        <input type="text" placeholder="City" />
        <p>
          <input type="checkbox" checked={this.props.score > 50}/>
          {' '}
          Show match jobs only
        </p>
      </form>
    );
  }
});
