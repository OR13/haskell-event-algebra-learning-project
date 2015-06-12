define(['react'], function(React) {
  return React.createClass({
    render: function() {
       var logNodes = this.props.data.map(function (logrow) {
         return (
           <tr>
             <td>{logrow.timestamp}</td>
             <td>{logrow.properties.accountID}</td>
             <td>{logrow.properties.deviceID}</td>
             <td>{logrow.properties.ad1}</td>
             <td>{logrow.properties.ad2}</td>
             <td>
               <pre>{logrow.properties.state}</pre>
             </td>
           </tr>
         );
       });
       return (
         <div className="row">
           <div className="large-12 large-centered columns">
             <table>
               <thead>
                 <th>Timestamp</th>
                 <th>AccountID</th>
                 <th>DeviceID</th>
                 <th>AD1</th>
                 <th>AD2</th>
                 <th>State</th>
               </thead>
               <tbody>
                 {logNodes}
               </tbody>
             </table>
           </div>
         </div>
       );
    }
  });
});
