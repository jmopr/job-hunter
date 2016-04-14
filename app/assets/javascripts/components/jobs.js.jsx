

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
